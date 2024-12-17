function showTaskDetails(button) {
    console.log(taskStatusDtos);
    const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute("content");

    const taskId = button.getAttribute("data-task-id");
    const documentType = button.getAttribute("data-document-type");
    const startDate = button.getAttribute("data-start-date");
    const endDate = button.getAttribute("data-end-date");
    const companyName = button.getAttribute("data-company-name");
    const companyInn = button.getAttribute("data-company-inn");
    const description = button.getAttribute("data-description");
    const amount = button.getAttribute("data-amount");
    const status = button.getAttribute("data-status");
    const isCompleted = status === "Сдан";

    const formattedStartDate = formatDate(startDate);
    const formattedEndDate = formatDate(endDate);
    const formattedAmount = formatAmount(amount);

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
<div style="background-color: #ffffff; padding: 20px; border-radius: 4px; position: relative; overflow: hidden; height: 610px">
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
                <p style="margin-top: 15px">Статус:</p>
            </div>
        
            <div class="values" style="font-size: 20px; display: inline">
                <p>${companyName}</p>
                <p>${companyInn}</p>
                <div id="date-display" style="display: block;">
                    <p>${formattedStartDate} - ${formattedEndDate} <button type="button" class="btn btn-link" onclick="editDate()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button></p>
                </div>
                <div id="date-input" style="display: none; height: 36px; align-items: center;">
                    <input type="text" id="from" name="from" style="width: 100px; height: 30px;" value="${formattedStartDate}">
                    <input type="text" id="to" name="to" style="width: 100px; height: 30px;" value="${formattedEndDate}">
                    <button type="button" class="btn btn-link" onclick="cancelEditDate()" style="padding: 0; margin-left: 10px;">
                        <img alt="Edit pen" src="/images/edit-pen.png" style="width: 20px; height: 20px;">
                    </button>
                </div>
                

                <div id="amount-display" style="display: block;">
                    <p>${formattedAmount !== "Не задано" ? formattedAmount + ' сом' : formattedAmount}<button type="button" class="btn btn-link" onclick="editAmount()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button></p>

                </div>
                <div id="amount-input" style="display: none;">
                    <input type="text" id="amount" name="amount" value="${formattedAmount !== "Не задано" ? formattedAmount : 0}" style="
                        width: 100px;
                        height: 33px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        font-size: 14px;
                        margin: 0;
                    ">
                    <button type="button" class="btn btn-link" onclick="cancelEditAmount()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button>
                </div>
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
        </div>

  <label for="description" style="margin-top: 55px; font-size: 14px; font-style: italic; font-weight: 100">Описание</label>
        <textarea id="description" name="description" style="width: 324px;
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
        <div style="display: flex; justify-content: center; margin-top: 50px">

        <button class="btn-save-task" type="submit" style="background-color: #ECE6F0; height: 51px; width: 219px; border-radius: 14px; display: flex; align-items: center; justify-content: center; box-shadow: -1px 0px 2px rgba(0, 0, 0, 0.3),
            0px 2px 5px rgba(0, 0, 0, 0.4);"><img alt="Edit pen" src="/images/save-edit-pen.png" style="max-width: 50px; max-height: 50px;"></button>
    </div>

    </form>
</div>
    `;

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

function setupCompanyToggleButton() {
    const companyHeader = document.querySelector(".company-column-th .company-header");

    if (!companyHeader) return;

    if (!companyHeader.querySelector(".btn-nav-img-toggle")) {
        const toggleButtonImage = document.createElement("img");
        toggleButtonImage.src = "/images/company-arrow.png";
        toggleButtonImage.alt = "Toggle Company Table";
        toggleButtonImage.classList.add("btn-nav-img", "btn-nav-img-toggle");
        toggleButtonImage.style.position = "absolute";
        toggleButtonImage.style.right = "5px";
        toggleButtonImage.style.top = "50%";
        toggleButtonImage.style.transform = "translateY(-50%)";
        toggleButtonImage.style.cursor = "pointer";
        toggleButtonImage.style.width = "24px";
        toggleButtonImage.style.height = "24px";

        toggleButtonImage.addEventListener("click", () => {
            toggleCompanyTable();
        });

        companyHeader.style.position = "relative";
        companyHeader.appendChild(toggleButtonImage);
    }
}

function toggleCompanyTable() {
    const companyTable = document.getElementById("company-table");
    const isHidden = companyTable.style.display === "none";
    if (isHidden) {
        companyTable.style.width = '244px';
        companyTable.style.marginRight = '5px';
        companyTable.style.transition = 'width 0.3s ease, padding 0.3s ease';
    } else {
        companyTable.style.width = '0';
        companyTable.style.marginRight = '0';
        companyTable.style.transition = 'width 0.3s ease, padding 0.3s ease';
    }
}

document.addEventListener("DOMContentLoaded", () => {
    setupCompanyToggleButton();
});


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
