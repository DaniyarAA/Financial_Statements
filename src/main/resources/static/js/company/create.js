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
