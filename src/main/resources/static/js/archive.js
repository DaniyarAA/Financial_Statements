const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');
const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

function toggleDetails(companyId) {
    const detailsRow = document.getElementById('details-' + companyId);
    if (detailsRow.style.display === "none") {
        detailsRow.style.display = "table-row";
    } else {
        detailsRow.style.display = "none";
    }
}

let selectedUserId;
let selectTaskId;

function openModal(userId) {
    selectedUserId = userId;
    document.getElementById('roleModal').style.display = 'block';
}

function openStatusModal(taskId) {
    selectTaskId = taskId;
    document.getElementById('statusModal').style.display = 'block';
}

function closeModal() {
    selectedUserId = null;
    document.getElementById('roleModal').style.display = 'none';
}

function closeStatusModal() {
    selectTaskId = null;
    document.getElementById('statusModal').style.display = 'none';
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

function showTab(tabId) {
    const tabs = document.querySelectorAll('.tab-content');
    const buttons = document.querySelectorAll('.tab-button');

    tabs.forEach(tab => tab.classList.remove('active'));
    buttons.forEach(button => button.classList.remove('active'));

    document.getElementById(tabId).classList.add('active');
    document.querySelector('.tab-button[onclick="showTab(' + tabId + ')"]').classList.add('active');

    localStorage.setItem('activeTab', tabId);
}

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
    const statusId = document.getElementById('statusSelect').value;
    if (!statusId) {
        alert('Выберите Статус.');
        return;
    }

    updateTaskStatus(selectTaskId, statusId);
    closeStatusModal();
}

function updateTaskStatus(taskId, statusId) {
    fetch('/archive/change_status/' + taskId, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            [csrfHeader]: csrfToken
        },
        body: JSON.stringify({statusId})
    })
        .then(response => {
            if (response.ok) {
                showNotification('Задача успешно изменила статус!', true);
                localStorage.setItem('activeTab', 'tasks');
                location.reload();
            } else {
                response.text().then(errorMessage => showNotification('Ошибка: ' + errorMessage, false));
            }
        })
        .catch(error => showNotification('Ошибка: ' + error.message, false));
}

document.addEventListener('DOMContentLoaded', () => {
    $('#users .styled-table').DataTable({
        paging: true,
        pageLength: 10,
        lengthMenu: [5, 10, 15, 100],
        searching: true,
        columnDefs: [
            { targets: [0, 7], orderable: false }
        ],
        language: {
            search: "Поиск:",
            lengthMenu: "Показать _MENU_ записей",
            info: "Показано _START_ до _END_ из _TOTAL_ записей",
            paginate: {
                first: "Первая",
                last: "Последняя",
                next: "Следующая",
                previous: "Предыдущая"
            },
            zeroRecords: "Совпадений не найдено",
        },
        responsive: true
    });

    $(document).ready(function () {
        const table = $('#tasksTable').DataTable({
            "pageLength": 5,
            "lengthMenu": [5, 10, 15, 100],
            "order": [[4, "asc"]],
            "searching": true,
            "columnDefs": [
                { "orderable": true, "targets": [1, 4, 5, 6] },
                { "orderable": false, "targets": "_all" },
                { "searchable": true, "targets": [1, 3] },
                { "searchable": false, "targets": "_all" }
            ]
        });

        $('#filterDocumentType').on('change', function () {
            const value = $(this).val();
            table.column(3).search(value ? '^' + $.fn.dataTable.util.escapeRegex(value) + '$' : '', true, false).draw();
        });
    });

});

document.getElementById('searchCompanies').addEventListener('input', function () {
    const searchValue = this.value.toLowerCase();
    const accordionItems = document.querySelectorAll('.accordion-item');

    accordionItems.forEach(item => {
        const companyName = item.querySelector('.accordion-button span').textContent.toLowerCase();
        if (companyName.includes(searchValue)) {
            item.style.display = '';
        } else {
            item.style.display = 'none';
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
        }
    });
});