function showTaskDetails(button) {
    console.log(taskStatusDtos);

    const container = document.querySelector('.container');
    container.classList.add('with-details');

    const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute("content");

    const taskId = button.getAttribute("data-task-id");
    const documentType = button.getAttribute("data-document-type");
    const startDate = button.getAttribute("data-start-date");
    const companyName = button.getAttribute("data-company-name");
    const companyInn = button.getAttribute("data-company-inn")
    const description = button.getAttribute("data-description");
    const amount = button.getAttribute("data-amount");
    const status = button.getAttribute("data-status");

    let statusOptions = '';
    taskStatusDtos.forEach((statusDto) => {
        const isSelected = statusDto.id == status ? 'selected' : '';
        statusOptions += `<option value="${statusDto.id}" ${isSelected}>${statusDto.name}</option>`;
    });

    document.getElementById('task-details').style.display = 'block';
    document.getElementById('task-content').innerHTML = `
    <div style="background-color: #ffffff; padding: 20px">

        <div>
            <p style="font-size: 24px">${documentType}</p>
        </div>
        <form id="task-edit-form" action="/tasks/edit/${taskId}" method="post">
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
                <input type="text" class="form-control" id="amount" name="amount" value="${amount}">
                <button type="button" class="btn btn-link" onclick="cancelEditAmount()">Cancel</button>
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

    <label for="description" class="form-label">Описание</label>
    <input type="text" class="form-control" id="description" name="description" value="${description}">
    
    <button type="submit" style="background-color: #ECE6F0; height: 51px; width: 219px; border-radius: 14px; display: flex; align-items: center; justify-content: center"><img alt="Edit pen" src="/images/save-edit-pen.png" style="max-width: 50px; max-height: 50px;"></button>
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