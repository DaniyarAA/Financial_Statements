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
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log('Success:', data);
                const editModal = bootstrap.Modal.getInstance(document.getElementById('editModal'));
                editModal.hide();
            })
            .catch((error) => {
                console.error('Error:', error);
            });
    }
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

