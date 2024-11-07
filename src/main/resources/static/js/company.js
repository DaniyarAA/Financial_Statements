function copyText(elementId) {
    const element = document.getElementById(elementId);
    let textToCopy;

    if (element.hasAttribute('data-password')) {
        textToCopy = element.getAttribute('data-password');
    } else {
        textToCopy = element.textContent;
    }

    navigator.clipboard.writeText(textToCopy).then(() => {
        addNotification(textToCopy + ' Скопировано');
    }).catch(err => {
        console.error('Ошибка копирования: ', err);
    });
}

function toggleCreateForm() {
    const createCompanyForm = document.getElementById('createCompanyForm');
    const companyInfo = document.getElementById('companyInfo');

    if (createCompanyForm.style.display === "block") {
        createCompanyForm.style.display = "none";
        companyInfo.style.display = "block";
    } else {
        companyInfo.style.display = "none";
        createCompanyForm.style.display = "block";
    }
}

async function submitForm(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const response = await fetch(event.target.action, {
        method: 'POST',
        body: formData
    });

    if (response.ok) {
        const result = await response.json();
        showResponseMessage(result.message);
    } else {
        const errors = await response.json();
        const errorMessages = Object.values(errors).join('\n');
        showResponseMessage(errorMessages, false);
    }
}

function addNotification(message) {
    const notification = document.createElement('div');
    notification.classList.add('notification');
    notification.textContent = message;

    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.opacity = '0';
        setTimeout(() => notification.remove(), 500);
    }, 3000);
}

function editText(elementId, companyID) {
    const textElement = document.getElementById(elementId);
    let currentText;

    if (textElement.hasAttribute('data-password')) {
        currentText = textElement.getAttribute('data-password');
    } else {
        currentText = textElement.textContent;
    }

    document.getElementById('editInput').value = currentText;
    document.getElementById('editFieldId').value = elementId;
    document.getElementById('editCompanyId').value = companyID;

    const editModal = new bootstrap.Modal(document.getElementById('editModal'));
    editModal.show();
}

function saveChanges() {
    const elementId = document.getElementById('editFieldId').value;
    const companyId = document.getElementById('editCompanyId').value;
    const newText = document.getElementById('editInput').value.trim();

    if (newText !== '') {
        document.getElementById(elementId).textContent = newText;

        const data = {
            companyId: companyId,
            field: elementId,
            value: newText
        };

        const csrfToken = document.querySelector('input[name="_csrf"]').value;

        fetch('/company/edit', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': csrfToken
            },
            body: JSON.stringify(data),
        })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(errData => {
                        throw new Error(errData.message || 'Ошибка при сохранении изменений , не удалось получить сообщение об ошибке от сервера');
                    });
                }
                return response.json();
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

function togglePasswordVisibility(passwordFieldId) {
    const passwordField = document.getElementById(passwordFieldId);
    const password = passwordField.getAttribute('data-password');

    if (passwordField.innerText === '••••••') {
        passwordField.innerText = password;
    } else {
        passwordField.innerText = '••••••';
    }
}

document.addEventListener("DOMContentLoaded", function() {
    loadFilters();
});

function updateFilter() {
    const sortValue = document.getElementById('sort').value;
    localStorage.setItem('companySort', sortValue);
    document.getElementById('filterForm').submit();
}

function loadFilters() {
    const sortValue = localStorage.getItem('companySort');
    if (sortValue) {
        document.getElementById('sort').value = sortValue;
    }
}

function clearSortFilter() {
    localStorage.removeItem('companySort');
}

