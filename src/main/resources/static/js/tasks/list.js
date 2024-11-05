function showTaskDetails(button) {
    document.getElementById('task-details').style.display = 'block';

    const taskId = button.getAttribute("data-task-id");
    const documentType = button.getAttribute("data-document-type");
    const startDate = button.getAttribute("data-start-date");
    const companyName = button.getAttribute("data-company-name");
    const description = button.getAttribute("data-description");
    const amount = button.getAttribute("data-amount");
    const status = button.getAttribute("data-status");

    const taskContent = `
        <p><strong>ID:</strong> ${taskId}</p>
        <p><strong>Тип документа:</strong> ${documentType}</p>
        <p><strong>С:</strong> ${startDate}</p>
        <p><strong>Компания:</strong> ${companyName}</p>
        <p><strong>Описание:</strong> ${description}</p>
        <p><strong>Сумма:</strong> ${amount}</p>
        <p><strong>Статус:</strong> ${status}</p>

    `;
    document.getElementById('task-content').innerHTML = taskContent;
}
