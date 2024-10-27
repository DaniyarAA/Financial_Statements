function copyText(elementId) {
    const textToCopy = document.getElementById(elementId).textContent;
    navigator.clipboard.writeText(textToCopy).then(() => {
        alert('Текст скопирован!');
    }).catch(err => {
        console.error('Ошибка копирования: ', err);
    });
}

function editText(elementId, companyID) {
    const textElement = document.getElementById(elementId);
    const currentText = textElement.textContent;
    const newText = prompt('Редактировать текст:', currentText);

    if (newText !== null && newText.trim() !== '') {
        textElement.textContent = newText;

        const data = new Map();
        data.set('companyId', companyID);
        data.set('field', elementId);
        data.set('value', newText);

        const plainData = Object.fromEntries(data);

        const csrfToken = document.querySelector('input[name="_csrf"]').value;

        fetch('/company/edit', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': csrfToken
            },
            body: JSON.stringify(plainData),
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log('Success:', data);
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

