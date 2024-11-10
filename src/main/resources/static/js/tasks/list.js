function showTaskDetails(button) {
    document.getElementById('task-details').style.display = 'block';

    const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute("content");

    const taskId = button.getAttribute("data-task-id");
    const documentType = button.getAttribute("data-document-type");
    const startDate = button.getAttribute("data-start-date");
    const companyName = button.getAttribute("data-company-name");
    const description = button.getAttribute("data-description");
    const amount = button.getAttribute("data-amount");
    const status = button.getAttribute("data-status");

    document.getElementById('task-content').innerHTML = `
        <form id="task-edit-form" action="/tasks/edit/${taskId}" method="post">
            <input type="hidden" name="_csrf" value="${csrfToken}">

            <div class="mb-3">
                <p><strong>ID:</strong> ${taskId}</p>
                <p><strong>Тип документа:</strong> ${documentType}</p>
                <p><strong>С:</strong> ${startDate}</p>
                <p><strong>Компания:</strong> ${companyName}</p>
                
                <div id="amount-display">
                    <p><strong>Сумма:</strong> <span id="amount-text">${amount}</span>
                    <button type="button" class="btn btn-link" onclick="editAmount()">Edit</button></p>
                </div>
                
                <div id="amount-input" style="display: none;">
                    <label for="amount" class="form-label">Сумма</label>
                    <input type="text" class="form-control" id="amount" name="amount" value="${amount}">
                    <button type="button" class="btn btn-link" onclick="cancelEditAmount()">Cancel</button>
                </div>

                <p><strong>Статус:</strong> ${status}</p>
                <label for="description" class="form-label">Описание</label>
                <input type="text" class="form-control" id="description" name="description" value="${description}">
            </div>
            <button type="submit" class="btn btn-primary">Сохранить изменения</button>
        </form>
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