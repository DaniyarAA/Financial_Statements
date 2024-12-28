function createNewDocumentType(){

}

function editDocumentType(elementId){
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

function cancelEditDocumentType(elementId){
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

function saveChangesDocumentType(elementId,documentTypeId ){

}