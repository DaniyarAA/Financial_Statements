function createNewTaskStatus(){

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

}

function saveChangesTaskStatus(elementId,taskStatusId){

}