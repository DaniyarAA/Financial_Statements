const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');
const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

let selectedUserId;
let selectTaskId;
let newStatusId;
let previousStatusName;
let currentDropdown;

function openModal(userId) {
    selectedUserId = userId;
    document.getElementById('roleModal').style.display = 'block';
}

function openStatusModal(taskId, taskName, dropdown) {
    selectTaskId = taskId;
    previousStatusName = dropdown.getAttribute('data-original-status');
    currentDropdown = dropdown;
    newStatusId = dropdown.value;
    document.getElementById('taskName').textContent = taskName;
    document.getElementById('statusModal').style.display = 'block';
}

function closeModal() {
    selectedUserId = null;
    document.getElementById('roleModal').style.display = 'none';
}

function closeStatusModal() {
    document.getElementById('statusModal').style.display = 'none';
    if (currentDropdown && previousStatusName) {
        for (const option of currentDropdown.options) {
            if (option.textContent.trim() === previousStatusName.trim()) {
                currentDropdown.value = option.value;
                break;
            }
        }
    }
}

function confirmRole() {
    const roleId = document.getElementById('roleSelect').value;
    if (!roleId) {
        alert('Выберите роль.');
        return;
    }

    resumeUserWithRole(selectedUserId, roleId);
    closeModal();
}

function showNotification(message, success) {
    const alert = document.createElement('div');
    alert.className = 'alert ' + success ? 'alert-success' : 'alert-danger' + ' fade show position-fixed top-0 end-0 m-3';
    alert.role = 'alert';
    alert.textContent = message;

    document.body.appendChild(alert);

    setTimeout(() => {
        alert.classList.remove('show');
        setTimeout(() => alert.remove(), 300);
    }, 3000);
}

document.addEventListener('DOMContentLoaded', () => {
    const activeTab = localStorage.getItem('activeTab');
    if (activeTab) {
        showTab(activeTab);
    }
});

function resumeCompany(companyId) {
    fetch('/archive/resume/company/' + companyId, {
        method: "POST",
        headers: {
            [csrfHeader]: csrfToken
        }
    })
        .then(response => {
            if (response.ok) {
                showNotification('Компания успешно восстановлена!', true);
                localStorage.setItem('activeTab', 'companies');
                location.reload();
            } else {
                showNotification('Ошибка при восстановлении компании.', false);
            }
        })
        .catch(error => showNotification('Ошибка: ' + error.message, false));
}

function resumeUserWithRole(userId, roleId) {
    fetch('/archive/resume/user/' + userId, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            [csrfHeader]: csrfToken
        },
        body: JSON.stringify({roleId})
    })
        .then(response => {
            if (response.ok) {
                showNotification('Пользователь успешно восстановлен!', true);
                localStorage.setItem('activeTab', 'users');
                location.reload();
            } else {
                showNotification('Ошибка при восстановлении пользователя.', false);
            }
        })
        .catch(error => showNotification('Ошибка: ' + error.message, false));
}

function confirmStatus() {
    if (!newStatusId) {
        alert('Выберите статус.');
        return;
    }
    updateTaskStatus(selectTaskId, newStatusId);
    closeStatusModal();
}

function updateTaskStatus(taskId, statusId) {
    fetch('/archive/change_status/' + taskId, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            [csrfHeader]: csrfToken
        },
        body: JSON.stringify({statusId: parseInt(statusId)})
    })
        .then(response => {
            if (response.ok) {
                showNotification('Задача успешно изменила статус!', true);

                const rowToRemove = document.querySelector(`tr[data-task-id="${taskId}"]`);
                if (rowToRemove) {
                    rowToRemove.remove();
                }

                const tableBody = document.querySelector('#tasksTable tbody');
                if (tableBody && tableBody.children.length === 0) {
                    tableBody.innerHTML = `
                        <tr>
                            <td colspan="9" class="no-data mt-2 mx-auto">Нет завершенных задач</td>
                        </tr>`;
                }
            } else {
                response.text().then(errorMessage => showNotification('Ошибка: ' + errorMessage, false));
            }
        })
        .catch(error => showNotification('Ошибка: ' + error.message, false));
}

document.addEventListener('DOMContentLoaded', () => {

    $('#tasksTable').DataTable({
        pageLength: 5,
        lengthMenu: [5, 10, 15, 100],
        order: [[4, "asc"]],
        searching: true,
        columnDefs: [
            {orderable: true, targets: [1, 4, 5, 6]},
            {orderable: false, targets: "_all"},
            {searchable: true, targets: [0, 2]},
            {searchable: false, targets: "_all"}
        ],
        language: {
            search: "",
            lengthMenu: "Показать _MENU_ записей",
            info: " _START_ - _END_ из _TOTAL_ ",
            paginate: {
                first: "Первая",
                last: "Последняя",
                next: "&raquo;",
                previous: "&laquo;"
            },
            zeroRecords: "Совпадений не найдено",
        },
        initComplete: function () {
            const searchInput = $('div.dataTables_filter input');
            searchInput.attr('placeholder', '  Введите наименование компании...');
        },
        infoCallback: function (settings, start, end, max, total, pre) {
            if (total === 0) {
                return "Нет записей для отображения.";
            }
            return `Показано ${start} - ${end} из ${total}`;
        },
        dom: "<'row align-items-center document-header'<'col-md-auto'l><'col-md-auto'f><'col-md-auto'i>>" +
            "<'row'<'col-12'tr>>" +
            "<'row'<'col-12'p>>",
        responsive: true
    });
    moveSortList();

    $('#filterDocumentType').on('change', function () {
        const value = $(this).val();
        $('#tasksTable').DataTable().column(2).search(
            value ? '^' + $.fn.dataTable.util.escapeRegex(value) + '$' : '',
            true, false
        ).draw();
    });


    $('#users .styled-table').DataTable({
        paging: true,
        pageLength: 10,
        lengthMenu: [5, 10, 15, 100],
        searching: true,
        columnDefs: [
            {targets: [0, 6], orderable: false}
        ],
        language: {
            search: "",
            lengthMenu: "Показать _MENU_ записей",
            info: " _START_ - _END_ из _TOTAL_ ",
            paginate: {
                first: "Первая",
                last: "Последняя",
                next: "&raquo;",
                previous: "&laquo;"
            },
            zeroRecords: "Совпадений не найдено",
        },
        initComplete: function () {
            const searchInputForUser = $('div.dataTables_filter.users input');
            searchInputForUser.attr('placeholder', '  Введите текст для поиска...');
        },
        infoCallback: function (settings, start, end, max, total, pre) {
            if (total === 0) {
                return "Нет записей для отображения.";
            }
            return `Показано ${start} - ${end} из ${total}`;
        },
        dom: "<'row align-items-center'<'col-md-auto'l><'col-md-auto'f><'col-md-auto'i>>" +
            "<'row'<'col-12'tr>>" +
            "<'row'<'col-12'p>>",
        responsive: true,
    });
});

function moveSortList() {
    const searchElement = document.getElementById('filterDocumentType');
    const searchContainer = document.querySelector('.document-header');
    const firstChild = searchContainer.lastChild;
    searchContainer.insertBefore(searchElement, firstChild);
}

function showTab(tabId) {
    document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
    document.querySelector(`[onclick="showTab('${tabId}')"]`).classList.add('active');
}

document.getElementById('searchCompanies').addEventListener('input', function () {
    const searchValue = this.value.toLowerCase();
    const accordionItems = document.querySelectorAll('.accordion-item');
    let hasResults = false;

    accordionItems.forEach(item => {
        const companyName = item.querySelector('.accordion-button span').textContent.toLowerCase();
        if (companyName.includes(searchValue)) {
            item.style.display = '';
            hasResults = true;
        } else {
            item.style.display = 'none';
        }
    });

    const noResultsMessage = document.getElementById('noResultsMessage');
    if (!hasResults) {
        if (!noResultsMessage) {
            const message = document.createElement('div');
            message.id = 'noResultsMessage';
            message.textContent = 'Нет результатов.';
            message.className = 'text-center text-muted my-3';
            document.querySelector('.accordion').appendChild(message);
        }
    } else {
        if (noResultsMessage) {
            noResultsMessage.remove();
        }
    }
});