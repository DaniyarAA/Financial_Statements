document.addEventListener("DOMContentLoaded", function () {
    const urlParams = new URLSearchParams(window.location.search);
    const taskId = urlParams.get('id');
    if (taskId) {
        window.history.replaceState({}, '', window.location.pathname);
        const taskButton = document.querySelector(`[data-task-id="${taskId}"]`);
        if (taskButton) {
            showTaskDetails(taskButton);
        } else {
            console.error("Кнопка с указанным ID не найдена.");
        }
    }
});



function showTaskDetails(button) {
    const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute("content");

    const taskId = button.getAttribute("data-task-id");
    const documentType = button.getAttribute("data-document-type");
    const startDate = button.getAttribute("data-start-date");
    const endDate = button.getAttribute("data-end-date");
    const companyId = button.getAttribute("data-company-id");
    const companyName = button.getAttribute("data-company-name");
    const companyInn = button.getAttribute("data-company-inn");
    const description = button.getAttribute("data-description");
    const amount = button.getAttribute("data-amount");
    const status = button.getAttribute("data-status");
    const isCompleted = status === "Сдан";
    const filePath = button.getAttribute("data-file-path");

    const formattedStartDate = formatDate(startDate);
    const formattedEndDate = formatDate(endDate);
    const formattedAmount = formatAmount(amount);

    const users = button.getAttribute("data-users");
    const parsedUsers = users ? JSON.parse(users) : [];

    console.log(parsedUsers);

    const taskDetails = document.getElementById('task-details');
    if (taskDetails) {
        taskDetails.style.width = '30%';
        taskDetails.border = '1px solid #dee2e6'
    }

    let statusOptions = '';
    taskStatusDtos.forEach((statusDto) => {
        const isSelected = statusDto.id == status ? 'selected' : '';
        statusOptions += `<option value="${statusDto.id}" ${isSelected}>${statusDto.name}</option>`;
    });

    const statusIndicatorColor = isCompleted ? '#15C24E' : '#C20B18';

    document.getElementById('task-details').style.display = 'block';
    document.getElementById('task-content').innerHTML = `
<div style="background-color: #ffffff; padding: 20px; border-radius: 4px; position: relative; overflow: hidden; height: 710px">
    <div class="status-indicator-task-details" style="
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 8px;
            background-color: ${statusIndicatorColor};
            pointer-events: none;
            z-index: 0;"></div>

    <div style="position: relative; z-index: 1;">
        <div style="display: flex; justify-content: center">

        <p style="font-size: 24px">${documentType}</p>
        </div>
    </div>
    <form id="task-edit-form" action="/tasks/edit/${taskId}" method="post" style="position: relative; z-index: 1;">
        <input type="hidden" name="_csrf" value="${csrfToken}">
        <div class="task-info">
            <div class="labels" style="font-size: 14px; font-style: italic; font-weight: 100; display: inline">
                <p>Компания:</p>
                <p>ИНН:</p>
                <p style="margin-top: 8px">Период:</p>
                <p style="margin-top: 15px">Сумма:</p>
                <p style="margin-top: 16px">Файл:</p>
                <p style="margin-top: 17px">Статус:</p>
                <p style="margin-top: 13px">Назначено:</p>
            </div>
        
            <div class="values" style="font-size: 20px; display: inline">
                <p class="truncate-text">${companyName}</p>
                <p>${companyInn}</p>
                
                <div style="display: inline; height: 34px">
                    <div id="date-display" style="display: block;">
                        <p>${formattedStartDate} - ${formattedEndDate} <button type="button" class="btn btn-link" onclick="editDate()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button></p>
                    </div>
                    <div id="date-input" style="display: none; height: 34px; align-items: center; margin-top: 5px; margin-bottom: 5px">
                        <input type="text" id="from" name="from" style="width: 100px; height: 30px;" value="${formattedStartDate}">
                        <input type="text" id="to" name="to" style="width: 100px; height: 30px;" value="${formattedEndDate}">
                        <button type="button" class="btn btn-link" onclick="cancelEditDate()" style="padding: 0; margin-left: 10px;">
                            <img alt="Edit pen" src="/images/edit-pen.png" style="width: 20px; height: 20px;">
                        </button>
                    </div>
                </div>
                
                <div style="display: inline; height: 34px">
                    <div id="amount-display" style="display: block;">
                        <p>${formattedAmount !== "Не задано" ? formattedAmount + ' сом' : formattedAmount}<button type="button" class="btn btn-link" onclick="editAmount()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button></p>
    
                    </div>
                    <div id="amount-input" style="display: none; height: 34px; margin-top: 5px; margin-bottom: 5px">
                        <input type="text" id="amount" name="amount" value="${formattedAmount !== "Не задано" ? formattedAmount : 0}" style="
                            width: 100px;
                            height: 34px;
                            border: 1px solid #ccc;
                            font-size: 14px;
                            margin-bottom: 0;
                        ">
                        <button type="button" class="btn btn-link" onclick="cancelEditAmount()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button>
                    </div>
                </div>
                
                <div style="display: inline; height: 38px">
                    <div id="file-display" style="display: flex; flex-direction: row; height: 38px">
                        <p class="truncate-text">${filePath}</p>
                            <button type="button" class="btn btn-link" onclick="editFile()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button>
                            ${filePath !== "Не задано" ? `
                                <button type="button" class="btn btn-link">
                                    <a href="api/files/download/${companyId}/${filePath}">
                                        <img src="/images/download.png" alt="Download icon" style="max-width: 20px; max-height: 20px;">
                                    </a>
                                </button>
                            ` : ''}
                    </div>
                    <div id="file-input" style="display: none; width: 250px; flex-direction: row">
                        <input type="file" class="form-control" id="file" name="file">
                        <p style="display: none;"></p>
                        <div class="invalid-feedback">
                            Выберите файл
                        </div>
                        <button type="button" class="btn btn-link" onclick="cancelEditFile()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button>
                    </div>
                </div>
                
                <div style="display: inline; height: 34px">
                    <div id="status-display" style="display: block">
                        <p>${status} <button type="button" class="btn btn-link" onclick="editStatus()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button></p>
                    </div>
                    <div id="status-input" style="display: none; align-items: center;">
                        <div style="display: flex; flex-direction: row">
                        <div>
                            <select class="form-select" id="taskStatus" name="statusId" style="
                            width: 200px; height: 38px;
                            ">
                                ${statusOptions}
                            </select>
                        </div>
          
                        <button type="button" class="btn btn-link" onclick="cancelEditStatus()" style="padding: 0; margin-left: 10px;">
                            <img alt="Edit pen" src="/images/edit-pen.png" style="width: 20px; height: 20px;">
                        </button>
                        </div>
                </div>    
                </div>
                    
                <div id="users-display"></div>

            </div>
        </div>

        <label for="description" style="margin-top: 60px; font-size: 14px; font-style: italic; margin-left: 10px; margin-bottom: 8px; font-weight: 100">Описание:</label>
        <textarea id="description" name="description" style="width: 95%; margin-left: 10px;
    height: 112px;
    background-color: #d9d9d9;
    color: #333;
    padding: 10px;
    border: none;
    border-radius: 8px;
    box-shadow: inset 2px 2px 5px rgba(0, 0, 0, 0.2), inset -2px -2px 5px rgba(255, 255, 255, 0.5);
    outline: none;
    font-size: 16px;
    resize: none;
    overflow-y: auto;">${description}</textarea>
        <div style="display: flex; justify-content: center; align-items: center; margin-top: 50px">

        <button class="btn-save-task" type="submit" style="background-color: #ECE6F0; height: 51px; width: 219px; border-radius: 14px; display: flex; align-items: center; justify-content: center; box-shadow: -1px 0 2px rgba(0, 0, 0, 0.3),
            0 2px 5px rgba(0, 0, 0, 0.4);"><img alt="Edit pen" src="/images/save-edit-pen.png" style="max-width: 50px; max-height: 50px;"></button>
    </div>

    </form>
</div>
    `;
    const usersDisplay = document.getElementById('users-display');
    if (usersDisplay) {
        if (parsedUsers.length > 0) {
            usersDisplay.innerHTML = `
            <div>
                ${parsedUsers
                .map(
                    (user, index) => `
                        <div style="display: inline-flex; align-items: center; margin-bottom: 5px; position: relative;">
                            <p style="margin: 0; font-size: 14px;">${user.surname.charAt(0)}. ${user.name}</p>
                            <button type="button" class="btn btn-link" data-index="${index}" style="padding: 0; margin-left: 8px; vertical-align: middle;">
                                <img alt="Edit pen" src="/images/edit-pen.png" style="width: 20px; height: 20px; vertical-align: middle;">
                            </button>
                            <div class="dropdown-menu" style="display: none; position: absolute; top: 100%; left: 0; background: white; border: 1px solid #ccc; border-radius: 4px; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);">
                                <ul style="list-style: none; margin: 0; padding: 5px 10px;">
                                    <li>
                                        <label>
                                            <input type="checkbox" name="option1"> Lorem ipsum.
                                        </label>
                                    </li>
                                    <li>
                                        <label>
                                            <input type="checkbox" name="option2"> Lorem ipsum dolor.
                                        </label>
                                    </li>
                                    <li>
                                        <label>
                                            <input type="checkbox" name="option3"> Lorem ipsum dolor sit.
                                        </label>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        `
                )
                .join('')}
            </div>
        `;
            document.querySelectorAll('.btn.btn-link').forEach(button => {
                button.addEventListener('click', function () {
                    toggleDropdown(button);
                });
            });
        } else {
            usersDisplay.innerHTML = '<p>Не задано</p>';
        }
    } else {
        console.error('Element with id "users-display" not found in the DOM.');
    }

    function toggleDropdown(button) {
        const dropdown = button.nextElementSibling;
        if (dropdown.style.display === 'none' || dropdown.style.display === '') {
            dropdown.style.display = 'block';
        } else {
            dropdown.style.display = 'none';
        }
    }

    var dateFormat = "dd.mm.yy";
    var from = $("#from").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        dateFormat: dateFormat
    }).on("change", function () {
        to.datepicker("option", "minDate", getDate(this));
    });

    var to = $("#to").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        dateFormat: dateFormat
    }).on("change", function () {
        from.datepicker("option", "maxDate", getDate(this));
    });
}

function handleFileUpload(event) {
    const fileInput = event.target;
    const file = fileInput.files[0];
    const fileDisplay = document.querySelector('.file-display a');
    const fileDisplayText = document.querySelector('.file-display p');

    if (file) {
        const fileName = file.name;

        if (fileDisplay) {
            fileDisplay.style.display = 'none';
        }

        if (!fileDisplayText) {
            const newFileDisplayText = document.createElement('p');
            newFileDisplayText.textContent = fileName;
            newFileDisplayText.style.margin = '10px 0';
            fileInput.parentElement.insertBefore(newFileDisplayText, fileInput);
        } else {
            fileDisplayText.textContent = fileName;
        }
    }
}

function formatDate(dateString) {
    const [year, month, day] = dateString.split("-");
    return `${day}.${month}.${year}`;
}

function formatAmount(amount) {
    if (!amount || amount === "Не задано") {
        return "Не задано";
    }
    return parseFloat(amount.replace(/,/g, '')).toFixed(2);
}

function editAmount() {
    document.getElementById('amount-display').style.display = 'none';
    document.getElementById('amount-input').style.display = 'block';

    const amountInput = document.getElementById('amount');
    const form = document.getElementById('task-edit-form');

    amountInput.addEventListener('input', validateAmount);

    function validateAmount() {
        const errorMessage = document.getElementById('amount-error');
        const value = amountInput.value.trim();

        if (!value || isNaN(value) || Number(value) <= 0) {
            if (!errorMessage) {
                const error = document.createElement('p');
                error.id = 'amount-error';
                error.textContent = 'Введите положительное число.';
                error.style.color = 'red';
                error.style.fontSize = '14px';
                error.style.marginTop = '5px';
                amountInput.parentNode.appendChild(error);
            }
            form.querySelector('button[type="submit"]').disabled = true;
        } else {
            if (errorMessage) errorMessage.remove();
            form.querySelector('button[type="submit"]').disabled = false;
        }
    }
}

function cancelEditAmount() {
    document.getElementById('amount-display').style.display = 'block';
    document.getElementById('amount-input').style.display = 'none';

    const errorMessage = document.getElementById('amount-error');
    if (errorMessage) errorMessage.remove();
    const form = document.getElementById('task-edit-form');
    form.querySelector('button[type="submit"]').disabled = false;
}

function editStatus() {
    document.getElementById('status-display').style.display = 'none';
    document.getElementById('status-input').style.display = 'block';
}

function cancelEditStatus() {
    document.getElementById('status-display').style.display = 'block';
    document.getElementById('status-input').style.display = 'none';
}

function editDate() {
    document.getElementById('date-display').style.display = 'none';
    document.getElementById('date-input').style.display = 'block';
}

function cancelEditDate() {
    document.getElementById('date-display').style.display = 'block';
    document.getElementById('date-input').style.display = 'none';
}

function editFile() {
    document.getElementById('file-display').style.display = 'none';
    document.getElementById('file-input').style.display = 'flex';
}

function cancelEditFile() {
    document.getElementById('file-display').style.display = 'flex';
    document.getElementById('file-input').style.display = 'none';
}

document.addEventListener("DOMContentLoaded", function () {
    const paginationContainer = document.querySelector('.pagination-container');

    if (paginationContainer) {
        paginationContainer.addEventListener('click', function (event) {
            const target = event.target.closest('.pagination-link');
            if (target) {
                const page = target.getAttribute('data-page');
                if (page !== null) {
                    navigateToPage(page);
                }
            }
        });
    }

    function navigateToPage(page) {
        const searchParams = new URLSearchParams(window.location.search);
        searchParams.set("page", page);
        window.location.href = `${window.location.pathname}?${searchParams.toString()}`;
    }
});
function setupNavigationButtons() {
    const yearMonthColumns = document.querySelectorAll(".year-month-th");

    if (yearMonthColumns.length >= 1) {
        const urlParams = new URLSearchParams(window.location.search);
        const currentYearMonth = urlParams.get("yearMonth") || getCurrentMonth();

        const firstColumn = yearMonthColumns[0];
        if (!firstColumn.querySelector(".btn-nav-img-prev")) {
            const prevButtonImage = document.createElement("img");
            prevButtonImage.src = "/images/prev-month.png";
            prevButtonImage.alt = "Previous Month";
            prevButtonImage.classList.add("btn-nav-img", "btn-nav-img-prev");
            prevButtonImage.style.position = "absolute";
            prevButtonImage.style.left = "5px";
            prevButtonImage.style.top = "0px";
            prevButtonImage.style.cursor = "pointer";
            prevButtonImage.style.width = "35px";
            prevButtonImage.style.height = "35px";

            const previousYearMonth = getAdjacentYearMonth(currentYearMonth, availableYearMonths, -1);
            if (!previousYearMonth) {
                prevButtonImage.style.filter = "grayscale(100%)";
                prevButtonImage.style.cursor = "not-allowed";
                prevButtonImage.classList.add("disabled");
            } else {
                prevButtonImage.addEventListener("click", () => {
                    window.location.href = updateURLParameter("yearMonth", previousYearMonth);
                });
            }

            firstColumn.style.position = "relative";
            firstColumn.appendChild(prevButtonImage);
        }

        const lastColumn = yearMonthColumns[yearMonthColumns.length - 1];
        if (!lastColumn.querySelector(".btn-nav-img-next")) {
            const nextButtonImage = document.createElement("img");
            nextButtonImage.src = "/images/next-month.png";
            nextButtonImage.alt = "Next Month";
            nextButtonImage.classList.add("btn-nav-img", "btn-nav-img-next");
            nextButtonImage.style.position = "absolute";
            nextButtonImage.style.right = "5px";
            nextButtonImage.style.top = "0px";
            nextButtonImage.style.cursor = "pointer";
            nextButtonImage.style.width = "35px";
            nextButtonImage.style.height = "35px";

            const nextYearMonth = getAdjacentYearMonth(currentYearMonth, availableYearMonths, 1);
            if (!nextYearMonth) {
                nextButtonImage.style.filter = "grayscale(100%)";
                nextButtonImage.style.cursor = "not-allowed";
                nextButtonImage.classList.add("disabled");
            } else {
                nextButtonImage.addEventListener("click", () => {
                    window.location.href = updateURLParameter("yearMonth", nextYearMonth);
                });
            }

            lastColumn.style.position = "relative";
            lastColumn.appendChild(nextButtonImage);
        }
    }

    function getAdjacentYearMonth(current, yearMonths, delta) {
        const currentIndex = yearMonths.indexOf(current);
        const newIndex = currentIndex + delta;

        if (newIndex >= 0 && newIndex < yearMonths.length) {
            return yearMonths[newIndex];
        }

        return null;
    }

    function updateURLParameter(key, value) {
        const searchParams = new URLSearchParams(window.location.search);
        searchParams.set(key, value);
        return `${window.location.pathname}?${searchParams.toString()}`;
    }

    function getCurrentMonth() {
        const date = new Date();
        return `${String(date.getMonth() + 1).padStart(2, "0")}.${date.getFullYear()}`;
    }
}

document.addEventListener("DOMContentLoaded", setupNavigationButtons);


function getDate(element) {
    var date;
    try {
        date = $.datepicker.parseDate(dateFormat, element.value);
    } catch (error) {
        date = null;
    }
    return date;
}

function addCollapseButtonToTaskDetails() {
    const taskDetailsHeader = document.querySelector('.task-details-header');

    if (!taskDetailsHeader.querySelector('.btn-collapse-task-details')) {
        const collapseButton = document.createElement('button');
        collapseButton.type = 'button';
        collapseButton.className = 'btn-collapse-task-details';
        collapseButton.style.cssText = `
            background: none;
            border: none;
            position: absolute;
            top: 10px;
            right: 10px;
            cursor: pointer;
        `;

        collapseButton.innerHTML = `<img src="/images/company-arrow.png" alt="Collapse" style="width: 24px; height: 24px;">`;

        collapseButton.addEventListener('click', () => {
            const taskDetails = document.getElementById('task-details');
            if (taskDetails) {
                taskDetails.style.width = '0';
                taskDetails.overflow = 'hidden';
                taskDetails.padding = '0';
                taskDetails.transition = 'width 0.3s ease, padding 0.3s ease';
            }
        });

        taskDetailsHeader.appendChild(collapseButton);
    }
}
document.addEventListener('DOMContentLoaded', () => {
    addCollapseButtonToTaskDetails();
});

function addCollapseButtonToCreateTask() {
    const taskCreateHeader = document.querySelector('.task-create-header');

    if (!taskCreateHeader.querySelector('.btn-collapse-task-create')) {
        const collapseButton = document.createElement('button');
        collapseButton.type = 'button';
        collapseButton.className = 'btn-collapse-task-create';
        collapseButton.style.cssText = `
            background: none;
            border: none;
            position: absolute;
            top: 10px;
            right: 10px;
            cursor: pointer;
        `;

        collapseButton.innerHTML = `<img src="/images/company-arrow.png" alt="Collapse" style="width: 24px; height: 24px;">`;

        collapseButton.addEventListener('click', () => {
            const taskCreate = document.getElementById('task-create');
            if (taskCreate) {
                taskCreate.style.width = '0';
                taskCreate.overflow = 'hidden';
                taskCreate.padding = '0';
                taskCreate.transition = 'width 0.3s ease, padding 0.3s ease';
            }
        });

        taskCreateHeader.appendChild(collapseButton);
    }
}
document.addEventListener('DOMContentLoaded', () => {
    addCollapseButtonToCreateTask();
});

function addCreateTaskButton() {
    const addTaskButton = document.createElement('button');
    addTaskButton.className = 'btn-create-task';
    addTaskButton.style.cssText = `
        background: none;
            border: none;
            position: absolute;
            top: 2px;
            right: 34px;
            cursor: pointer;
    `;

    addTaskButton.innerHTML = `<img src="/images/add.png" alt="Collapse" style="width: 40px; height: 40px;">`;

    addTaskButton.addEventListener('click', () => {
        toggleCreateTaskForm();
    });

    document.body.appendChild(addTaskButton);
}

document.addEventListener('DOMContentLoaded', () => {
    addCreateTaskButton();
});


function toggleCreateTaskForm() {
    const createTaskForm = document.getElementById('task-create');
    createTaskForm.style.width = '30%';
    createTaskForm.style.transition = 'width 0.3s ease, padding 0.3s ease';
}

function showSecondPage() {
    const formPage1 = document.getElementById('formPage1');
    const formPage2 = document.getElementById('formPage2');

    formPage1.classList.add('slide-out-left');
    formPage1.addEventListener('animationend', () => {
        formPage1.style.display = 'none';
        formPage1.classList.remove('slide-out-left');

        formPage2.style.display = 'block';
        formPage2.classList.add('slide-in-right');
        formPage2.addEventListener('animationend', () => {
            formPage2.classList.remove('slide-in-right');
        }, { once: true });
    }, { once: true });
}

function showFirstPage() {
    const formPage1 = document.getElementById('formPage1');
    const formPage2 = document.getElementById('formPage2');

    formPage2.classList.add('slide-out-right');
    formPage2.addEventListener('animationend', () => {
        formPage2.style.display = 'none';
        formPage2.classList.remove('slide-out-right');

        formPage1.style.display = 'block';
        formPage1.classList.add('slide-in-left');
        formPage1.addEventListener('animationend', () => {
            formPage1.classList.remove('slide-in-left');
        }, { once: true });
    }, { once: true });
}

document.addEventListener("DOMContentLoaded", function() {
    const openModal = document.getElementById('openModal').value;
    if (openModal === 'true') {
        toggleCreateTaskForm()
    }
});


document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("task-details");

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        const editForm = document.getElementById("task-edit-form");
        const formData = new FormData(editForm);
        const actionUrl = editForm.getAttribute("action");

        const existingAlert = document.getElementById("alertMessage");
        if (existingAlert) {
            existingAlert.remove();
        }

        fetch(actionUrl, {
            method: "POST",
            body: formData,
            csrfToken: csrfToken

        })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => Promise.reject(err));
                }
                return response.json();
            })
            .then(data => {
                showAlert(data.success || "Задача успешно обновлена!", "success");
            })
            .catch(error => {
                showAlert(error.error || "Возникла ошибка.", "error");
            });
    });

    function showAlert(message, type) {
        const alertDiv = document.createElement("div");
        alertDiv.id = "alertMessage";
        alertDiv.textContent = message;
        alertDiv.style.position = "absolute";
        alertDiv.style.top = "20px";
        alertDiv.style.right = "20px";
        alertDiv.style.padding = "15px 20px";
        alertDiv.style.borderRadius = "8px";
        alertDiv.style.color = "#fff";
        alertDiv.style.fontSize = "14px";
        alertDiv.style.boxShadow = "0px 2px 5px rgba(0, 0, 0, 0.2)";
        alertDiv.style.zIndex = "1000";

        if (type === "success") {
            alertDiv.style.backgroundColor = "#28a745";
        } else {
            alertDiv.style.backgroundColor = "#dc3545";
        }

        document.body.appendChild(alertDiv);

        setTimeout(() => {
            alertDiv.remove();
            if (type === "success") {
                window.location.reload();
            }
        }, 2000);
    }
    const sidebar = document.querySelector('.company-table');
    const taskListWrapper = document.querySelector('.tasks-table');
    if (!taskListWrapper){
        console.log("Не нашел")
    }

    if (sidebar && taskListWrapper) {
        sidebar.addEventListener('scroll', () => {
            taskListWrapper.scrollTop = sidebar.scrollTop;
            console.log("HHHH")
        });

        taskListWrapper.addEventListener('scroll', () => {
            console.log("hhh")
            sidebar.scrollTop = taskListWrapper.scrollTop;
        });
    } else {
        console.error('Ошибка синхронизации скролла');
    }
});

document.addEventListener("DOMContentLoaded", function () {
    const createTaskForm = document.getElementById("form-create");

    if (createTaskForm) {
        createTaskForm.addEventListener("submit", function (e) {
            e.preventDefault();

            const formData = new FormData(createTaskForm);
            const actionUrl = createTaskForm.getAttribute("action");

            const existingAlert = document.getElementById("alertMessage");
            if (existingAlert) {
                existingAlert.remove();
            }

            fetch(actionUrl, {
                method: "POST",
                body: formData,
            })
                .then((response) => {
                    if (!response.ok) {
                        return response.json().then((err) => Promise.reject(err));
                    }
                    return response.json();
                })
                .then((data) => {
                    showAlert(data.success || "Задача успешно создана!", "success");
                })
                .catch((error) => {
                    showAlert(error.error || "Возникла ошибка при создании задачи.", "error");
                });
        });
    }

    function showAlert(message, type) {
        const alertDiv = document.createElement("div");
        alertDiv.id = "alertMessage";
        alertDiv.textContent = message;
        alertDiv.style.position = "absolute";
        alertDiv.style.top = "20px";
        alertDiv.style.right = "20px";
        alertDiv.style.padding = "15px 20px";
        alertDiv.style.borderRadius = "8px";
        alertDiv.style.color = "#fff";
        alertDiv.style.fontSize = "14px";
        alertDiv.style.boxShadow = "0px 2px 5px rgba(0, 0, 0, 0.2)";
        alertDiv.style.zIndex = "1000";

        if (type === "success") {
            alertDiv.style.backgroundColor = "#28a745";
        } else {
            alertDiv.style.backgroundColor = "#dc3545";
        }

        document.body.appendChild(alertDiv);

        setTimeout(() => {
            alertDiv.remove();
            if (type === "success") {
                window.location.reload();
            }
        }, 2000);
    }
});


function openCompanyPopup() {
    const modal = document.getElementById("company-modal");
    const dropdown = document.getElementById("modal-company-dropdown");
    modal.style.display = "block";

    populateModalDropdown(companyDtos);
}

function closeCompanyPopup() {
    const modal = document.getElementById("company-modal");
    modal.style.display = "none";
}

function populateModalDropdown(companies) {
    const dropdown = document.getElementById("modal-company-dropdown");
    dropdown.innerHTML = "";

    companies.forEach(company => {
        const li = document.createElement("li");
        li.textContent = company.name;
        li.className = "dropdown-item";
        li.dataset.companyId = company.id;

        li.addEventListener("click", () => {
            selectCompanyFromModal(company);
        });

        dropdown.appendChild(li);
    });
}

function updateModalDropdown() {
    const searchValue = document.getElementById("company-modal-search").value.toLowerCase();
    const filteredCompanies = companyDtos.filter(company =>
        company.name.toLowerCase().includes(searchValue)
    );

    populateModalDropdown(filteredCompanies);
}

function selectCompanyFromModal(company) {
    const searchInput = document.getElementById("company-search");
    const hiddenInput = document.getElementById("company-id");

    searchInput.value = company.name;
    hiddenInput.value = company.id;

    onCompanySelected(company.id);

    closeCompanyPopup();
}


document.addEventListener("click", event => {
    const modal = document.getElementById("company-modal");
    if (event.target === modal) {
        closeCompanyPopup();
    }
});

let selectedCompanyUsers = [];

function openUserPopup() {
    const modal = document.getElementById("user-modal");
    modal.style.display = "block";

    populateUserModalDropdown(selectedCompanyUsers);
}

// Close User Popup
function closeUserPopup() {
    const modal = document.getElementById("user-modal");
    modal.style.display = "none";
}

// Populate User Dropdown
function populateUserModalDropdown(users) {
    const dropdown = document.getElementById("modal-user-dropdown");
    dropdown.innerHTML = "";

    users.forEach(user => {
        const li = document.createElement("li");
        li.textContent = `${user.surname} ${user.name}`;
        li.className = "dropdown-item";
        li.dataset.userId = user.id;

        li.addEventListener("click", () => {
            selectUserFromModal(user);
        });

        dropdown.appendChild(li);
    });
}

function updateUserModalDropdown() {
    const searchValue = document.getElementById("user-modal-search").value.toLowerCase();
    const filteredUsers = selectedCompanyUsers.filter(user =>
        `${user.surname} ${user.name}`.toLowerCase().includes(searchValue)
    );

    populateUserModalDropdown(filteredUsers);
}

function selectUserFromModal(user) {
    const searchInput = document.getElementById("user-search");
    const hiddenInput = document.getElementById("user-id");

    searchInput.value = `${user.surname} ${user.name}`;
    hiddenInput.value = user.id;

    closeUserPopup();
}

function onCompanySelected(companyId) {
    const company = companyDtos.find(c => c.id === companyId);
    selectedCompanyUsers = company ? company.users : [];
}



