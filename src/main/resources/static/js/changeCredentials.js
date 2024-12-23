const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');
const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
document.addEventListener("DOMContentLoaded", function () {
    const togglePasswordVisibility = (inputId, toggleButtonId, iconId) => {
        const input = document.getElementById(inputId);
        const toggleButton = document.getElementById(toggleButtonId);
        const icon = document.getElementById(iconId);

        toggleButton.addEventListener("click", () => {
            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("bi-eye-slash");
                icon.classList.add("bi-eye");
            } else {
                input.type = "password";
                icon.classList.remove("bi-eye");
                icon.classList.add("bi-eye-slash");
            }
        });
    };

    togglePasswordVisibility("newPassword", "toggleNewPassword", "newPasswordEyeIcon");
    togglePasswordVisibility("confirmPassword", "toggleConfirmPassword", "confirmPasswordEyeIcon");

    window.saveLoginAndPassword = async function () {
        const newUsername = document.getElementById("newUsername").value;
        const newPassword = document.getElementById("newPassword").value;
        const confirmPassword = document.getElementById("confirmPassword").value;
        const loginErrorMessage = document.getElementById("loginErrorMessage");
        const passwordErrorMessage = document.getElementById("passwordErrorMessage");

        loginErrorMessage.textContent = '';
        passwordErrorMessage.textContent = '';

        if (newPassword !== confirmPassword) {
            passwordErrorMessage.textContent = "Пароли не совпадают.";
            return;
        }

        if (newUsername === "") {
            loginErrorMessage.textContent = 'Заполните поле логин!';
            return;
        }

        if (newPassword.length < 8 || newPassword.length > 20 || confirmPassword.length > 20 || confirmPassword.length < 8) {
            passwordErrorMessage.textContent = "длина пароли должно быть от 8 до 20 символов!"
            if (newPassword === "") {
                passwordErrorMessage.textContent = 'Заполните пароль!';
            }

            if (confirmPassword === ""){
                passwordErrorMessage.textContent = 'Заполните пароль!';
            }
            return;
        }

        try {
            const response = await fetch("/change-credentials", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    [csrfHeader]: csrfToken
                },
                body: JSON.stringify({newUsername, newPassword})
            });

            if (response.ok) {
                displaySuccessAlert("Данные успешно обновлены. Пожалуйста, авторизуйтесь заново.");
                location.href = "/login";
            }else if (!response.ok) {
                const errorData = await response.json();
                console.error("Ошибка сервера:", errorData);
                if (errorData.message.includes("логин")) {
                    loginErrorMessage.textContent = errorData.message;
                } else {
                    passwordErrorMessage.textContent = errorData.message;
                }
            }
        } catch (error) {
            console.error("Ошибка при обновлении данных:", error);
            passwordErrorMessage.textContent = "Придумайте более надежный пароль.";
        }
    };
});
function displaySuccessAlert(message) {
    const alertContainer = document.createElement('div');
    alertContainer.className = 'alert alert-success alert-dismissible fade show';
    alertContainer.role = 'alert';
    alertContainer.style.fontSize = '1.1rem';
    alertContainer.innerHTML = message + '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>';

    document.body.appendChild(alertContainer);

    setTimeout(() => {
        alertContainer.remove();
    }, 5000);
}