function showTaskDetails(button) {
    document.getElementById('task-details').style.display = 'block';

    const taskId = button.getAttribute("data-task-id");
    const documentType = button.getAttribute("data-document-type");
    const startDate = button.getAttribute("data-start-date");
    const companyName = button.getAttribute("data-company-name");
    const description = button.getAttribute("data-description");
    const amount = button.getAttribute("data-amount");
    const status = button.getAttribute("data-status");

    document.getElementById('task-content').innerHTML = `
    <p><strong>ID:</strong> ${taskId}</p>
    <p><strong>Тип документа:</strong> ${documentType}</p>
    <p><strong>С:</strong> ${startDate}</p>
    <p><strong>Компания:</strong> ${companyName}</p>
    <p><strong>Описание:</strong> <span id="description">${description}</span></p>
    <button onclick="editText('description', ${taskId})" title="Редактировать" class="btn btn-link p-0">
        <p>Edit</p>
    </button>
    <p><strong>Сумма:</strong> ${amount}</p>
    <p><strong>Статус:</strong> ${status}</p>
`;
}

function editText(elementId, taskID) {
    const textElement = document.getElementById(elementId);
    if (!textElement) {
        console.error(`Element with ID "${elementId}" not found.`);
        return;
    }

    const currentText = textElement.textContent;

    document.getElementById('editInput').value = currentText;
    document.getElementById('editFieldId').value = elementId;
    document.getElementById('editTaskId').value = taskID;

    const editModal = new bootstrap.Modal(document.getElementById('editModal'));
    editModal.show();
}

function saveChanges() {
    const elementIdInput = document.getElementById('editFieldId');
    const taskIdInput = document.getElementById('editTaskId');
    const editInput = document.getElementById('editInput');

    if (!elementIdInput || !taskIdInput || !editInput) {
        console.error('One or more modal input elements are missing:', {
            elementIdInput,
            taskIdInput,
            editInput
        });
        showResponseMessage('Error: Some fields are missing in the edit modal.', false);
        return;
    }

    const elementId = elementIdInput.value;
    const taskId = taskIdInput.value;
    const newText = editInput.value.trim();

    if (newText !== '') {
        const textElement = document.getElementById(elementId);
        if (textElement) {
            textElement.textContent = newText;
        } else {
            console.error(`Element with ID "${elementId}" not found on the page.`);
            showResponseMessage(`Element with ID "${elementId}" not found on the page.`, false);
            return;
        }

        const data = {
            taskId: taskId,
            field: elementId,
            value: newText
        };

        const csrfToken = document.querySelector('input[name="_csrf"]')?.value;
        if (!csrfToken) {
            console.error("CSRF token not found");
            showResponseMessage("CSRF token not found.", false);
            return;
        }

        fetch('/tasks/edit', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': csrfToken
            },
            body: JSON.stringify(data),
        })
            .then(response => {
                if (!response.ok) {
                    return response.clone().text().then(text => {
                        try {
                            const json = JSON.parse(text);
                            throw new Error(json.message || 'Failed to save changes.');
                        } catch {
                            console.error('Non-JSON error response received:', text);
                            throw new Error('Unexpected error: ' + text || 'Failed to save changes.');
                        }
                    });
                }
                return response.text().then(text => {
                    if (text) {
                        return JSON.parse(text);
                    } else {
                        throw new Error('Empty response from server.');
                    }
                });
            })
            .then(data => {
                showResponseMessage(data.message);
                const editModal = bootstrap.Modal.getInstance(document.getElementById('editModal'));
                editModal.hide();
            })
            .catch(error => {
                showResponseMessage(error.message, false);
                console.error('Error:', error);
            });


    }
}

function showResponseMessage(message, isSuccess = true) {
    const notification = document.createElement('div');
    notification.classList.add('notification');
    notification.textContent = message;

    if (isSuccess) {
        notification.style.backgroundColor = "#d4edda";
        notification.style.color = "#155724";
        notification.style.borderColor = "#c3e6cb";
    } else {
        notification.style.backgroundColor = "#f8d7da";
        notification.style.color = "#721c24";
        notification.style.borderColor = "#f5c6cb";
    }

    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.opacity = '0';
        setTimeout(() => notification.remove(), 500);
    }, 3000);
}
