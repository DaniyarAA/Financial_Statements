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

document.addEventListener("DOMContentLoaded", function() {
    const openModal = document.getElementById('openModal').value;
    const createCompanyModalElement = document.getElementById('createCompanyModal');
    const createCompanyModal = new bootstrap.Modal(createCompanyModalElement);

    if (openModal === 'true') {
        createCompanyModal.show();
    }
});

function closeModalCreate() {
    var modal = bootstrap.Modal.getInstance(document.getElementById('createCompanyModal'));
    modal.hide();
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
        var modal = bootstrap.Modal.getInstance(document.getElementById('createCompanyModal'));
        modal.hide();
        const currentUrl = new URL(window.location.href);
        currentUrl.searchParams.delete('openModal');
        window.location.href = currentUrl.toString();
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

function editText(elementId, companyId) {
    const textElement = document.getElementById(elementId);
    const inputElement = document.getElementById(`editInput${elementId}`);
    const saveBtn = document.getElementById(`saveBtn${elementId}`);
    const cancelBtn = document.getElementById(`cancelBtn${elementId}`);
    const editBtn = document.getElementById(`editBtn${elementId}`);
    let currentText;

    if (textElement.hasAttribute('data-password')) {
        currentText = textElement.getAttribute('data-password');
    } else {
        currentText = textElement.textContent.trim();
    }

    textElement.classList.add('d-none');
    inputElement.classList.remove('d-none');
    saveBtn.classList.remove('d-none');
    cancelBtn.classList.remove('d-none');
    editBtn.classList.add('d-none');
    inputElement.value = currentText;
}


function saveChanges(elementId, companyId) {
    const inputElement = document.getElementById(`editInput${elementId}`);
    const newText = inputElement.value.trim();

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
                        throw new Error(errData.message || 'Ошибка при сохранении изменений');
                    });
                }
                return response.json();
            })
            .then(data => {
                showResponseMessage(data.message);
                cancelEdit(elementId);
            })
            .catch(error => {
                showResponseMessage(error.message, false);
                console.error('Error:', error);
            });
    }
}

function cancelEdit(elementId) {
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

function togglePasswordVisibility(passwordFieldId, button) {
    const passwordField = document.getElementById(passwordFieldId);
    const icon = button.querySelector('i');
    const password = passwordField.getAttribute('data-password');

    if (passwordField.innerText === '•'.repeat(password.length)) {
        passwordField.innerText = password;
        icon.classList.remove('bi-eye');
        icon.classList.add('bi-eye-slash');
    } else {
        passwordField.innerText = '•'.repeat(password.length);
        icon.classList.remove('bi-eye-slash');
        icon.classList.add('bi-eye');
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


document.addEventListener('DOMContentLoaded', function () {
    document.querySelector('#search').oninput = function () {
        let value = this.value.trim().toLowerCase();
        let totalCompany = document.querySelectorAll('.search li');
        let dropdownMenu = document.querySelector('#total');
        let matches = 0;

        totalCompany.forEach(function (elem) {
            let link = elem.querySelector('a');
            let text = link.innerText.toLowerCase();

            if (text.includes(value)) {
                elem.classList.remove('hide');
                matches++;
            } else {
                elem.classList.add('hide');
            }
        });

        if (matches > 0) {
            dropdownMenu.classList.add('show');
        } else {
            dropdownMenu.classList.remove('show');
        }
    };
});


document.addEventListener("DOMContentLoaded", function() {
    const container = document.getElementById('total');

    const scrollTop = localStorage.getItem('scrollTop');
    if (scrollTop !== null) {
        container.scrollTop = scrollTop;
    }


    const activeElement = document.querySelector('.choice-company.active');
    if (activeElement) {
        activeElement.scrollIntoView({
            behavior: 'auto',
            block: 'nearest'
        });
    }


    container.addEventListener('scroll', function() {
        localStorage.setItem('scrollTop', container.scrollTop);
    });
});