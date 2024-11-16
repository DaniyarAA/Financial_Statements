const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');
const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

window.onload = function () {
    const viewMode = localStorage.getItem('viewMode');
    if (viewMode === 'tile') {
        switchToTileView();
    } else {
        switchToListView();
    }
};

function switchToTileView() {
    document.getElementById('tileView').classList.remove('hidden');
    document.getElementById('listView').classList.add('hidden');
    localStorage.setItem('viewMode', 'tile');
}

function switchToListView() {
    document.getElementById('listView').classList.remove('hidden');
    document.getElementById('tileView').classList.add('hidden');
    localStorage.setItem('viewMode', 'list');
}

document.addEventListener("DOMContentLoaded", function () {
    const savedViewMode = localStorage.getItem('viewMode');
    if (savedViewMode === 'tile') {
        switchToTileView();
    } else {
        switchToListView();
    }
});


document.addEventListener("DOMContentLoaded", function () {
    const userModal = document.getElementById("userModal");

    function handleSaveUserData(userId) {
        saveUserData(userId);
    }

    const companySearchInput = document.getElementById("companySearch");
    const companyCheckboxes = document.getElementById("companyCheckboxes");

    companySearchInput.addEventListener("input", function () {
        const searchTerm = companySearchInput.value.toLowerCase();

        Array.from(companyCheckboxes.children).forEach(div => {
            const label = div.querySelector("label");
            if (label.textContent.toLowerCase().includes(searchTerm)) {
                div.style.display = "flex";
            } else {
                div.style.display = "none";
            }
        });
    });

    userModal.addEventListener("show.bs.modal", function (event) {
        const button = event.relatedTarget;
        const avatarInput = document.getElementById("avatarInput");
        const deleteUserIcon = document.getElementById("delete-user-icon");
        const userId = button.getAttribute("data-user-id");
        deleteUserIcon.setAttribute("data-user-id", userId);
        avatarInput.setAttribute("data-user-id", userId);

        fetch(`/admin/users/edit/` + userId)
            .then(response => response.json())
            .then(data => {
                const user = data.user;
                const companies = data.companies;
                const roles = data.roles;

                document.getElementById("userModalLabel").innerText = user.name;
                document.getElementById("surnameModalLabel").innerText = user.surname;
                document.getElementById("surnameNameInput").value = user.surname;
                const birthday = user.birthday;
                const [year, month, day] = birthday.split('-');
                document.getElementById("user-birthday").innerText = `${month}.${day}.${year}`;
                document.getElementById("user-status").innerText = user.enabled ? "Активен" : "Неактивен";
                document.getElementById("user-login").innerText = user.login;
                document.getElementById("notesInput").value = user.notes;
                document.getElementById("userNameInput").value = user.name;
                document.getElementById("birthday-input").value = birthday
                if (user.avatar) {
                    document.getElementById("avatar").src = `/api/files/download/${user.avatar}`;
                } else {
                    document.getElementById("avatar").src = `/api/files/download/user.png`;

                }

                const roleDisplay = document.getElementById("roleDisplay");
                const roleSelect = document.getElementById("roleSelect");
                roleDisplay.innerText = user.roleDto.roleName;
                roleSelect.innerHTML = "";
                roles.forEach(role => {
                    const option = document.createElement("option");
                    option.value = role.id;
                    option.textContent = role.roleName;
                    if (role.id === user.roleDto.id) {
                        option.selected = true;
                    }
                    roleSelect.append(option);
                });

                const initialCompanies = document.getElementById("initialCompanies");
                initialCompanies.innerHTML = user.companies.slice(0, 1).map(company => company.name).join(", ");
                if (user.companies.length > 1) {
                    initialCompanies.innerHTML += ", ...";
                } else if (user.companies.length === 0) {
                    initialCompanies.innerHTML += "Отсутствуют"
                }

                const companyCheckboxes = document.getElementById("companyCheckboxes");
                companyCheckboxes.innerHTML = "";
                const sortedCompanies = companies.sort((a, b) => {
                    const aChecked = user.companies.some(userCompany => userCompany.id === a.id);
                    const bChecked = user.companies.some(userCompany => userCompany.id === b.id);
                    return bChecked - aChecked;
                });

                sortedCompanies.forEach((company, index) => {
                    const checkbox = document.createElement("input");
                    checkbox.type = "checkbox";
                    checkbox.value = company.id;
                    checkbox.id = `company_${company.id}`;
                    checkbox.checked = user.companies.some(userCompany => userCompany.id === company.id);

                    const label = document.createElement("label");
                    label.setAttribute("for", `company_${company.id}`);
                    label.textContent = `${index + 1}) ${company.name}`;

                    const div = document.createElement("div");
                    div.style.display = "flex";
                    div.style.justifyContent = "space-between";
                    div.style.alignItems = "center";

                    div.append(label);
                    div.append(checkbox);

                    companyCheckboxes.append(div);
                });
                const editUserBtn = document.getElementById("edit-user-info-button");
                editUserBtn.removeEventListener("click", handleSaveUserData);
                editUserBtn.addEventListener("click", () => handleSaveUserData(userId));

            })
            .catch(error => console.error("Error loading user data:", error));
    });
});

function uploadAvatar() {
    const avatarInput = document.getElementById("avatarInput");
    const avatarImg = document.getElementById("avatar");
    const userId = avatarInput.getAttribute("data-user-id");

    avatarInput.onchange = async function () {
        const file = avatarInput.files[0];
        if (!file) {
            alert("Файл не выбран.");
            return;
        }

        const formData = new FormData();
        formData.append("file", file);

        try {
            const response = await fetch(`/api/files/upload/avatar/${userId}`, {
                method: "POST",
                headers: {
                    [csrfHeader]: csrfToken
                },
                body: formData
            });

            const data = await response.json();
            if (data.success) {
                const resultFileName = data.resultFileName;
                avatarImg.src = `/api/files/download/${resultFileName}`;
                showNotification("Аватарка успешно обновлена!", "green");
            } else {
                showNotification("Ошибка при обновлении аватарки.", "red");
            }
        } catch (error) {
            console.error("Ошибка:", error);
            showNotification("Произошла ошибка при отправке запроса.", "red");
        }
    };

    avatarInput.click();
}

document.addEventListener("DOMContentLoaded", function () {
    const changePasswordModal = document.getElementById("changeLoginPasswordModal");
    let userId = document.getElementById("currentUserId").value || null;

    changePasswordModal.addEventListener("show.bs.modal", function (event) {
        const button = event.relatedTarget;
        userId = button.getAttribute("data-user-id") || userId;
    });

    async function saveLoginAndPassword() {
        const newLogin = document.getElementById("newLogin").value;
        const newPassword = document.getElementById("newPassword").value;
        const confirmPassword = document.getElementById("confirmPassword").value;
        const loginErrorMessage = document.getElementById("loginErrorMessage");
        const passwordErrorMessage = document.getElementById("passwordErrorMessage");

        loginErrorMessage.textContent = '';
        passwordErrorMessage.textContent = '';

        if (!userId) {
            alert('Ошибка: userId отсутствует. Пожалуйста, обновите страницу.');
            return;
        }

        if (newPassword !== confirmPassword) {
            passwordErrorMessage.textContent = 'Пароли не совпадают';
            return;
        }

        if (newLogin === "") {
            loginErrorMessage.textContent = 'Заполните поле логин!';
            return;
        }

        try {
            const response = await fetch(`/admin/users/change-login-password/${userId}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    [csrfHeader]: csrfToken
                },
                body: JSON.stringify({newLogin, newPassword})
            });

            if (response.ok) {
                const modalInstance = bootstrap.Modal.getInstance(changePasswordModal);
                modalInstance.hide();
                displaySuccessAlert('Данные обновлены');
                setTimeout(() => location.reload(), 1000);

            } else {
                const errorData = await response.json();
                if (errorData.message) {
                    if (errorData.message.includes('логин')) {
                        loginErrorMessage.textContent = errorData.message;
                    } else {
                        passwordErrorMessage.textContent = errorData.message;
                    }
                }
            }
        } catch (error) {
            console.error("Ошибка при обновлении данных пользователя:", error);
            passwordErrorMessage.textContent = 'Произошла ошибка при отправке запроса';
        }
    }

    window.saveLoginAndPassword = saveLoginAndPassword;
});

function displaySuccessAlert(message) {
    const alertContainer = document.createElement('div');
    alertContainer.className = 'alert alert-success alert-dismissible fade show';
    alertContainer.role = 'alert';
    alertContainer.style.fontSize = '1.1rem';
    alertContainer.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;

    document.body.appendChild(alertContainer);

    setTimeout(() => {
        alertContainer.remove();
    }, 5000);
}

let isSaving = false;

function saveUserData(userId) {
    if (isSaving) {
        return;
    }
    isSaving = true;
    const roleSelect = document.getElementById("roleSelect");
    const username = document.getElementById("userNameInput").value;
    const birthday = document.getElementById("birthday-input").value;
    const login = document.getElementById("user-login-input").value;
    const surname = document.getElementById("surnameNameInput").value;
    const selectedRoleDto = {
        id: roleSelect.value,
        roleName: roleSelect.options[roleSelect.selectedIndex].textContent
    };
    const notes = document.getElementById("notesInput").value;
    const companies = Array.from(document.querySelectorAll("#companyCheckboxes input:checked")).map(checkbox => {
        const label = document.querySelector(`label[for="${checkbox.id}"]`);
        return {
            id: checkbox.value,
            name: label ? label.textContent.trim() : ""
        };
    });


    const userDto = {
        roleDto: selectedRoleDto,
        notes: notes,
        companies: companies,
        name: username,
        birthday: birthday,
        login: login,
        surname: surname

    };

    fetch(`/admin/users/edit/` + userId, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            [csrfHeader]: csrfToken
        },
        body: JSON.stringify(userDto)
    })
        .then(response => {
            isSaving = false;
            if (response.ok) {
                location.reload();
            } else {
                return response.json().then(errorData => {

                    if (errorData && errorData.error) {
                        if (errorData.error === "duplicate") {
                            document.getElementById("loginError").innerText = errorData.message;
                        } else {
                            document.getElementById("birthdayError").innerText = errorData.message;
                        }
                    }
                    showNotification("Ошибка при обновлении информации", "red");
                });
            }
        })
        .catch(error => console.error("Error saving user data:", error));
}

function deleteUser() {
    const deleteUserIcon = document.getElementById("delete-user-icon");
    const userStatus = document.getElementById("user-status");
    const userId = deleteUserIcon.getAttribute("data-user-id");
    if (confirm('Вы уверены, что хотите удалить этого пользователя?')) {
        fetch('/admin/user/delete/' + userId, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader]: csrfToken
            }
        })
            .then(response => {
                if (response.ok) {
                    showNotification("Пользователь успешно удалён.", "green");
                    userStatus.innerText = "Неактивен"
                } else {
                    return response.json().then(errorData => {
                        showNotification(errorData.message, "red");
                    });
                }
            })
            .catch(error => {
                console.error('Ошибка:', error);
                showNotification("Ошибка при удалении пользователя.", "red");
            });
    }
}

function showNotification(message, color) {
    const notification = document.getElementById("notification");
    notification.textContent = message;
    notification.style.display = "block";
    notification.style.opacity = "1";
    notification.style.backgroundColor = color;

    setTimeout(() => {
        notification.style.opacity = "0";
        setTimeout(() => {
            notification.style.display = "none";
        }, 500);
    }, 3000);
}

function toggleCompanyEdit() {
    const initialCompanies = document.getElementById('initialCompanies');
    const companyDropdown = document.getElementById('companyDropdown');
    const editIcon = document.getElementById('edit-company-icon');
    if (companyDropdown.style.display === 'none') {
        initialCompanies.style.display = 'none';
        companyDropdown.style.display = 'inline-block';
        editIcon.style.display = 'none';
    } else {
        closeDropdown();
    }
}

function closeDropdown() {
    const initialCompanies = document.getElementById('initialCompanies');
    const companyDropdown = document.getElementById('companyDropdown');
    const editIcon = document.getElementById('edit-company-icon');

    initialCompanies.style.display = 'inline';
    companyDropdown.style.display = 'none';
    editIcon.style.display = 'inline';

    document.removeEventListener('click', closeDropdown);
}

document.addEventListener('click', function (event) {
    const companyDropdown = document.getElementById('companyDropdown');
    const editIcon = document.getElementById('edit-company-icon');

    if (!companyDropdown.contains(event.target) && event.target !== editIcon) {
        closeDropdown();
    }
});

function toggleRoleEdit() {
    const roleDisplay = document.getElementById('roleDisplay');
    const roleSelect = document.getElementById('roleSelect');
    if (roleSelect.style.display === 'none') {
        roleDisplay.style.display = 'none';
        roleSelect.style.display = 'inline-block';
    } else {
        roleDisplay.innerText = roleSelect.options[roleSelect.selectedIndex].textContent;
        roleDisplay.style.display = 'inline';
        roleSelect.style.display = 'none';
    }
}

function toggleNameEdit() {
    const userModalLabel = document.getElementById('userModalLabel');
    const surnameModalLabel = document.getElementById('surnameModalLabel');
    const userNameInput = document.getElementById('userNameInput');
    const surnameNameInput = document.getElementById('surnameNameInput');

    const isEditing = userNameInput.style.display === 'inline-block';

    if (!isEditing) {
        userNameInput.style.display = 'inline-block';
        surnameNameInput.style.display = 'inline-block';
        userModalLabel.style.display = 'none';
        surnameModalLabel.style.display = 'none';
        userNameInput.value = userModalLabel.innerText;
        surnameNameInput.value = surnameModalLabel.innerText;
    } else {
        userModalLabel.innerText = userNameInput.value;
        surnameModalLabel.innerText = surnameNameInput.value;
        userModalLabel.style.display = 'block';
        surnameModalLabel.style.display = 'block';
        userNameInput.style.display = 'none';
        surnameNameInput.style.display = 'none';
    }
}

function toggleBirthdayEdit() {
    const birthdayDisplay = document.getElementById("user-birthday");
    const birthdayInput = document.getElementById("birthday-input");

    if (birthdayInput.style.display === 'none') {
        const displayDate = birthdayDisplay.innerText;
        const dateParts = displayDate.split('.');
        birthdayInput.value = `${dateParts[2]}-${dateParts[0]}-${dateParts[1]}`;
        birthdayInput.style.display = 'inline-block';
        birthdayDisplay.style.display = 'none';
    } else {
        const dateParts = birthdayInput.value.split('-');
        birthdayDisplay.innerText = `${dateParts[1]}.${dateParts[2]}.${dateParts[0]}`;
        birthdayDisplay.style.display = 'inline';
        birthdayInput.style.display = 'none';
    }
}

document.addEventListener("DOMContentLoaded", async function () {
    try {
        const response = await fetch('/admin/login-check');
        const requiresChange = await response.json();

        if (!requiresChange) {
            const userModal = new bootstrap.Modal(document.getElementById('changeLoginPasswordModal'));
            userModal.show();
        }
    } catch (error) {
        console.error("Ошибка при проверке данных пользователя:", error);
    }
});