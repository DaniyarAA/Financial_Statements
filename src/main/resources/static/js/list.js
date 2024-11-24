function showTaskDetails(button) {
    console.log(taskStatusDtos);

    const container = document.querySelector('.container');
    container.classList.add('with-details');

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

    let statusOptions = '';
    taskStatusDtos.forEach((statusDto) => {
        const isSelected = statusDto.id == status ? 'selected' : '';
        statusOptions += `<option value="${statusDto.id}" ${isSelected}>${statusDto.name}</option>`;
    });

    const statusIndicatorColor = isCompleted ? '#15C24E' : '#C20B18';

    document.getElementById('task-details').style.display = 'block';
    document.getElementById('task-content').innerHTML = `
<div style="background-color: #ffffff; padding: 20px; border-radius: 4px; position: relative; overflow: hidden;">
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
                <p>Период:</p>
                <p style="margin-top: 7px">Сумма:</p>
                <p style="margin-top: 15px">Статус:</p>
            </div>
        
            <div class="values" style="font-size: 20px; display: inline">
                <p>${companyName}</p>
                <p>${companyInn}</p>
                <div id="date-display" style="display: block;">
                    <p>${formattedStartDate} - ${formattedEndDate} <button type="button" class="btn btn-link" onclick="editDate()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button></p>
                </div>
                <div id="date-input" style="display: none">
                    <input type="text" id="from" name="from" style="width: 100px; height: 30px;" value="${formattedStartDate}">
                    <input type="text" id="to" name="to" style="width: 100px; height: 30px;" value="${formattedEndDate}">
                    <button type="button" class="btn btn-link" onclick="cancelEditDate()"><img alt="Edit pen" src="/images/cross.png" style="max-width: 20px; max-height: 20px;"></button>

                </div>
                

                <div id="amount-display" style="display: block;">
                    <p>${amount} сом<button type="button" class="btn btn-link" onclick="editAmount()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button></p>
                </div>
                <div id="amount-input" style="display: none;">
                    <input type="text" id="amount" name="amount" value="${amount}" style="
                        width: 100px;
                        height: 33px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        font-size: 14px;
                        margin: 0;
                    ">
                    <button type="button" class="btn btn-link" onclick="cancelEditAmount()"><img alt="Edit pen" src="/images/cross.png" style="max-width: 20px; max-height: 20px;"></button>

                </div>
                <div id="status-display" style="display: block">
                    <p>${status} <button type="button" class="btn btn-link" onclick="editStatus()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button></p>
                </div>
                <div id="status-input" style="display: none;">
                    <select class="form-select" id="taskStatus" name="statusId" style="
                    width: 200px;
                    ">
                        ${statusOptions}
                    </select>
                    <button type="button" class="btn btn-link" onclick="cancelEditStatus()"><img alt="Edit pen" src="/images/cross.png" style="max-width: 20px; max-height: 20px;"></button>
          
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

        <button type="submit" style="background-color: #ECE6F0; height: 51px; width: 219px; border-radius: 14px; display: flex; align-items: center; justify-content: center;             box-shadow: -1px 0px 2px rgba(0, 0, 0, 0.3),
            0px 2px 5px rgba(0, 0, 0, 0.4);"><img alt="Edit pen" src="/images/save-edit-pen.png" style="max-width: 50px; max-height: 50px;"></button>
    </div>

    </form>
</div>
    `;

    var dateFormat = "mm/dd/yy";
    var from = $("#from").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1
    }).on("change", function () {
        to.datepicker("option", "minDate", getDate(this));
    });

    var to = $("#to").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1
    }).on("change", function () {
        from.datepicker("option", "maxDate", getDate(this));
    });
}

function formatDate(dateString) {
    const [year, month, day] = dateString.split("-");
    return `${day}.${month}.${year}`;
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