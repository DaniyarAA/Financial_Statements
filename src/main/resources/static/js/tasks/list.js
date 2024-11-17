function showTaskDetails(button) {
    console.log(taskStatusDtos);

    const container = document.querySelector('.container');
    container.classList.add('with-details');

    const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute("content");

    const taskId = button.getAttribute("data-task-id");
    const documentType = button.getAttribute("data-document-type");
    const startDate = button.getAttribute("data-start-date");
    const companyName = button.getAttribute("data-company-name");
    const companyInn = button.getAttribute("data-company-inn");
    const description = button.getAttribute("data-description");
    const amount = button.getAttribute("data-amount");
    const status = button.getAttribute("data-status");
    const isCompleted = status === "Сдан";

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
                <p>Сумма:</p>
                <p>Статус:</p>
            </div>
        
            <div class="values" style="font-size: 20px; display: inline">
                <p>${companyName}</p>
                <p>${companyInn}</p>
                <p>${startDate}</p>
                <div id="amount-display" style="display: block;">
                    <p>${amount} сом<button type="button" class="btn btn-link" onclick="editAmount()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button></p>
                </div>
                <div id="amount-input" style="display: none;">
    <input type="text" id="amount" name="amount" value="${amount}" style="
        width: 70px;
        height: 15px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 14px;
        margin: 0;
    ">
    <button type="button" onclick="cancelEditAmount()" style="
        background: none;
        color: #007bff;
        border: none;
        cursor: pointer;
        padding: 0;
        text-decoration: underline;
        font-size: 14px;
    ">Cancel</button>
</div>
                <div id="status-display" style="display: block">
                    <p>${status} <button type="button" class="btn btn-link" onclick="editStatus()"><img alt="Edit pen" src="/images/edit-pen.png" style="max-width: 20px; max-height: 20px;"></button></p>
                </div>
                <div id="status-input" style="display: none;">
                    <select class="form-select" id="taskStatus" name="statusId">
                        ${statusOptions}
                    </select>
                <button type="button" class="btn btn-link" onclick="cancelEditStatus()">Cancel</button>
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
}


function editAmount() {
    document.getElementById('amount-display').style.display = 'none';
    document.getElementById('amount-input').style.display = 'block';
}

function cancelEditAmount() {
    document.getElementById('amount-display').style.display = 'block';
    document.getElementById('amount-input').style.display = 'none';
}

function editStatus() {
    document.getElementById('status-display').style.display = 'none';
    document.getElementById('status-input').style.display = 'block';
}

function cancelEditStatus() {
    document.getElementById('status-display').style.display = 'block';
    document.getElementById('status-input').style.display = 'none';
}

document.addEventListener("DOMContentLoaded", function () {
    const urlParams = new URLSearchParams(window.location.search);
    const currentYearMonth = urlParams.get("yearMonth") || getCurrentMonth();
    const currentYearMonthSpan = document.getElementById("currentYearMonth");

    currentYearMonthSpan.textContent = formatYearMonth(currentYearMonth);

    document.getElementById("prevYearMonth").addEventListener("click", function () {
        navigateToYearMonth(-1, currentYearMonth);
    });

    document.getElementById("nextYearMonth").addEventListener("click", function () {
        navigateToYearMonth(1, currentYearMonth);
    });

    function navigateToYearMonth(delta, current) {
        const newYearMonth = computeNewYearMonth(current, delta);
        window.location.href = updateURLParameter("yearMonth", newYearMonth);
    }

    function computeNewYearMonth(current, delta) {
        const [month, year] = current.split(".").map(Number);
        const date = new Date(year, month - 1 + delta);
        return `${String(date.getMonth() + 1).padStart(2, "0")}.${date.getFullYear()}`;
    }

    function updateURLParameter(key, value) {
        const searchParams = new URLSearchParams(window.location.search);
        searchParams.set(key, value);
        return `${window.location.pathname}?${searchParams.toString()}`;
    }

    function formatYearMonth(yearMonth) {
        const [month, year] = yearMonth.split(".");
        const monthNames = [
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December",
        ];
        return `${monthNames[Number(month) - 1]} ${year}`;
    }

    function getCurrentMonth() {
        const date = new Date();
        return `${String(date.getMonth() + 1).padStart(2, "0")}.${date.getFullYear()}`;
    }
});

function setupNavigationButtons() {
    const yearMonthColumns = document.querySelectorAll(".year-month-th");

    if (yearMonthColumns.length >= 2) {
        const urlParams = new URLSearchParams(window.location.search);
        const currentYearMonth = urlParams.get("yearMonth") || getCurrentMonth();

        // Handle the first column
        const firstColumn = yearMonthColumns[0];
        if (!firstColumn.querySelector(".btn-nav-img")) { // Avoid duplicates
            const prevButtonImage = document.createElement("img");
            prevButtonImage.src = "/images/prev-month.png"; // Path to your image
            prevButtonImage.alt = "Previous Month";
            prevButtonImage.classList.add("btn-nav-img");
            prevButtonImage.style.position = "absolute";
            prevButtonImage.style.left = "5px";
            prevButtonImage.style.top = "0px";
            prevButtonImage.style.cursor = "pointer";
            prevButtonImage.style.width = "35px";
            prevButtonImage.style.height = "35px";

            prevButtonImage.addEventListener("click", () => {
                navigateToYearMonth(-1, currentYearMonth);
            });

            firstColumn.style.position = "relative";
            firstColumn.appendChild(prevButtonImage);
        }

        // Handle the last column
        const lastColumn = yearMonthColumns[yearMonthColumns.length - 1];
        if (!lastColumn.querySelector(".btn-nav-img")) { // Avoid duplicates
            const nextButtonImage = document.createElement("img");
            nextButtonImage.src = "/images/next-month.png"; // Path to your image
            nextButtonImage.alt = "Next Month";
            nextButtonImage.classList.add("btn-nav-img");
            nextButtonImage.style.position = "absolute";
            nextButtonImage.style.right = "5px";
            nextButtonImage.style.top = "0px";
            nextButtonImage.style.cursor = "pointer";
            nextButtonImage.style.width = "35px";
            nextButtonImage.style.height = "35px";

            nextButtonImage.addEventListener("click", () => {
                navigateToYearMonth(1, currentYearMonth);
            });

            lastColumn.style.position = "relative";
            lastColumn.appendChild(nextButtonImage);
        }
    }

    function navigateToYearMonth(delta, current) {
        const newYearMonth = computeNewYearMonth(current, delta);
        window.location.href = updateURLParameter("yearMonth", newYearMonth);
    }

    function computeNewYearMonth(current, delta) {
        const [month, year] = current.split(".").map(Number);
        const date = new Date(year, month - 1 + delta);
        return `${String(date.getMonth() + 1).padStart(2, "0")}.${date.getFullYear()}`;
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
