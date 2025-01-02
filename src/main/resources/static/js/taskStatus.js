async function createNewTaskStatus(event){
    event.preventDefault();

    const formData = new FormData(event.target);
    const response = await fetch(event.target.action, {
        method: 'POST',
        body: formData
    });

    if (response.ok) {
        location.reload();
    } else {
        const errors = await response.json();
        showResponseMessageInTaskStatusToolsError(errors.message,true);
    }
}

function editTaskStatus(elementId) {
    const textElement = document.getElementById(elementId);
    const inputElement = document.getElementById(`editInput${elementId}`);
    const saveBtn = document.getElementById(`saveBtn${elementId}`);
    const cancelBtn = document.getElementById(`cancelBtn${elementId}`);
    const editBtn = document.getElementById(`editBtn${elementId}`);

    if (textElement && inputElement && saveBtn && cancelBtn && editBtn) {
        const currentText = textElement.textContent.trim();
        textElement.classList.add('d-none');
        inputElement.classList.remove('d-none');
        saveBtn.classList.remove('d-none');
        cancelBtn.classList.remove('d-none');
        editBtn.classList.add('d-none');
        inputElement.value = currentText;
    }
}

function cancelEditTaskStatus(elementId){
    const textElement = document.getElementById(elementId);
    const inputElement = document.getElementById(`editInput${elementId}`);
    const saveBtn = document.getElementById(`saveBtn${elementId}`);
    const cancelBtn = document.getElementById(`cancelBtn${elementId}`);
    const editBtn = document.getElementById(`editBtn${elementId}`);

    textElement.classList.remove('d-none');
    inputElement.classList.add('d-none');
    saveBtn.classList.add('d-none');
    cancelBtn.classList.add('d-none');
    editBtn.classList.remove('d-none');
}

function saveChangesTaskStatus(elementId,taskStatusId){
    const inputElement = document.getElementById(`editInput${elementId}`);
    const nextText = inputElement.value.trim();

    if (nextText !== '') {
        document.getElementById(elementId).textContent = nextText;

        const data = {
            taskStatusId: taskStatusId,
            field:'name',
            value:nextText
        };

        const csrfToken = document.querySelector('input[name="_csrf"]').value;

        fetch('/status/edit',{
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': csrfToken
            },
            body: JSON.stringify(data),
        })
            .then(response =>{
                if (!response.ok) {
                    return response.json().then(errData => {
                        throw new Error(errData.message || 'Ошибка при сохранений изменений!')
                    });
                }
                return response.json();
            })
            .then(data => {
                location.reload();
            })
            .catch(error => {
                showResponseMessageInTaskStatusToolsError(error.message,false);
                console.log('Error',error);
            });
    }
}

function showResponseMessageInTaskStatusToolsError(message, isSuccess = true) {
    const spanDocumentTypeError = document.getElementById(`taskStatusToolsError`);
    spanDocumentTypeError.innerText = message;

    if (isSuccess) {
        spanDocumentTypeError.style.color = "#155724";
    } else {
        spanDocumentTypeError.style.color = "#721c24";
    }

}

function deleteTask(taskId) {
    const csrfToken = document.querySelector('input[name="_csrf"]').value;
    fetch('/status/delete',{
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': csrfToken
        },
        body: JSON.stringify({ id: taskId }),
    })
        .then(response =>{
            if (!response.ok) {
                return response.json().then(errData => {
                    throw new Error(errData.message || 'Ошибка при удалении!')
                });
            }
            return response.json();
        })
        .then(data => {
           location.reload();
        })
        .catch(error => {
            showResponseMessageInDocumentTypeNameError(error.message,false);
            console.log('Error',error);
        });
}