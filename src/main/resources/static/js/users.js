const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');
const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

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
    const editUserBtn = document.getElementById("edit-user-info-button");
    let currentUserId = null;
    console.log(document.querySelectorAll("#userModal").length);



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
        currentUserId = button.getAttribute("data-user-id");
        if (deleteUserIcon){
            deleteUserIcon.setAttribute("data-user-id", currentUserId);
        }
        if(avatarInput){
            avatarInput.setAttribute("data-user-id", currentUserId);
        }

        console.log("Fetching user data for:", currentUserId);
        fetch(`/admin/users/edit/` + currentUserId)
            .then(response => response.json())
            .then(data => {
                console.log("Data fetched for user:", data.user);
                const user = data.user;
                const companies = data.companies;
                const roles = data.roles;
                if(!user.enabled){
                    document.getElementById('edit-company-icon').style.display = 'none';
                    document.getElementById('edit-name-icon').style.display = 'none';
                    document.getElementById('edit-birthday-icon').style.display = 'none';
                    document.getElementById('change-avatar-icon').style.display = 'none';
                    document.getElementById('edit-role-icon').style.display = 'none';
                    document.getElementById('delete-user-icon').style.display = 'none';
                    document.getElementById('companyDropdown').disabled = true;
                    document.getElementById('notesInput').disabled = true;
                    document.getElementById('edit-user-info-button').disabled = true;
                }
                if(user.roleDto && user.roleDto.roleName === "SuperUser"){
                    console.error(user.roleDto.roleName);
                    document.getElementById("delete-user-icon").style.display = 'none';
                    document.getElementById("edit-role-icon").style.display = 'none';
                }

                document.getElementById("userModalLabel").innerText = user.name;
                document.getElementById("surnameModalLabel").innerText = user.surname;
                document.getElementById("surnameNameInput").value = user.surname;
                const birthday = user.birthday;
                const [year, month, day] = birthday.split('-');
                document.getElementById("user-birthday").innerText = `${month}.${day}.${year}`;
                document.getElementById("user-status").innerText = user.enabled ? "Активен" : "Неактивен";
                document.getElementById("notesInput").value = user.notes;
                document.getElementById("userNameInput").value = user.name;
                document.getElementById("birthday-input").value = birthday;
                if (user.avatar) {
                    document.getElementById("avatar").src = `/api/files/download/${user.avatar}`;
                } else {
                    document.getElementById("avatar").src = `/api/files/download/user.png`;

                }

                const roleDisplay = document.getElementById("roleDisplay");
                const roleSelect = document.getElementById("roleSelect");
                if(user.roleDto){
                    roleDisplay.innerText = user.roleDto.roleName;
                } else {
                    roleDisplay.innerText = "Отсутствует";
                }


                if(user.roleDto){
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
                }

                const initialCompanies = document.getElementById("initialCompanies");
                const maxLength = 19;
                let displayText = user.companies.slice(0, 2).map(company => company.name).join(", ");
                if (displayText.length > maxLength) {
                    displayText = displayText.slice(0, maxLength - 3) + '...';
                } else if (user.companies.length === 0){
                    displayText = "Отсутствуют";
                }
                initialCompanies.innerHTML = displayText;

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

            })
            .catch(error => console.error("Error loading user data:", error));
    });
    editUserBtn.addEventListener("click", function () {
        if (currentUserId) {
            saveUserData(currentUserId);
        }
    });
});

function uploadAvatar() {
    const avatarInput = document.getElementById("avatarInput");
    const avatarImg = document.getElementById("avatar");
    const userId = avatarInput.getAttribute("data-user-id");

    avatarInput.onchange = async function() {
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
                showNotification(data.message, "red");
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
    const toggleNewPassword = document.getElementById("toggleNewPassword");
    const newPasswordInput = document.getElementById("newPassword");
    const newPasswordEyeIcon = document.getElementById("newPasswordEyeIcon");

    const toggleConfirmPassword = document.getElementById("toggleConfirmPassword");
    const confirmPasswordInput = document.getElementById("confirmPassword");
    const confirmPasswordEyeIcon = document.getElementById("confirmPasswordEyeIcon");

    toggleNewPassword.addEventListener("click", function () {
        if (newPasswordInput.type === "password") {
            newPasswordInput.type = "text";
            newPasswordEyeIcon.classList.remove("bi-eye-slash");
            newPasswordEyeIcon.classList.add("bi-eye");
        } else {
            newPasswordInput.type = "password";
            newPasswordEyeIcon.classList.remove("bi-eye");
            newPasswordEyeIcon.classList.add("bi-eye-slash");
        }
    });

    toggleConfirmPassword.addEventListener("click", function () {
        if (confirmPasswordInput.type === "password") {
            confirmPasswordInput.type = "text";
            confirmPasswordEyeIcon.classList.remove("bi-eye-slash");
            confirmPasswordEyeIcon.classList.add("bi-eye");
        } else {
            confirmPasswordInput.type = "password";
            confirmPasswordEyeIcon.classList.remove("bi-eye");
            confirmPasswordEyeIcon.classList.add("bi-eye-slash");
        }
    });

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

function saveUserData(userId) {
    const roleSelect = document.getElementById("roleSelect");
    const username = document.getElementById("userNameInput").value;
    const birthday = document.getElementById("birthday-input").value;
    const surname = document.getElementById("surnameNameInput").value;
    const fullnameDispay = document.getElementById(userId + "-name-surname");
    const currentNameSurname = fullnameDispay.innerText;
    const parts = currentNameSurname.split('.');
    const userRoleDisplay = document.getElementById(userId + "-role")
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
            if (response.ok) {
                fullnameDispay.innerText = `${parts[0]}.${username} ${surname}`;
                userRoleDisplay.innerText = selectedRoleDto.roleName;
                const modalElement = document.getElementById('userModal');
                const modalInstance = bootstrap.Modal.getInstance(modalElement);
                if (modalInstance) {
                    modalInstance.hide();
                    modalElement.addEventListener('hidden.bs.modal', () => {
                        document.querySelectorAll('.modal-backdrop').forEach(backdrop => backdrop.remove());
                    }, { once: true });
                }
                showNotification("Информация успешно обновлена!", "green");


            } else {
                return response.json().then(errorData => {
                    document.getElementById("birthdayError").innerText = errorData.message;
                    showNotification("Ошибка при обновлении информации", "red");
                });
            }
        })
        .catch(error => console.error("Error saving user data:", error));
}

function deleteUser() {
    const deleteUserIcon = document.getElementById("delete-user-icon");
    const displayRole = document.getElementById("roleDisplay");
    const userStatus = document.getElementById("user-status");
    const userId = deleteUserIcon.getAttribute("data-user-id");
    const confirmModal = new bootstrap.Modal(document.getElementById('confirmModal'));
    const userStatusOnList = document.getElementById(`${userId}-list-status`);
    const userStatusOnTile = document.getElementById(`${userId}-tile-status`);

    confirmModal.show();
    document.getElementById('confirmYes').onclick = function() {
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
                    userStatus.innerText = "Неактивен";
                    displayRole.innerText = "Отсутвует";
                    userStatusOnList.innerText = "Disabled";
                    userStatusOnTile.innerText = "Disabled";
                    confirmModal.hide();
                } else {
                    return response.json().then(errorData => {
                        confirmModal.hide();
                        showNotification(errorData.message, "red");
                    });
                }
            })
            .catch(error => {
                console.error('Ошибка:', error);
                confirmModal.hide();
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
    if (companyDropdown.style.display === 'none') {
        initialCompanies.style.display = 'none';
        companyDropdown.style.display = 'inline-block';
        attachCheckboxListeners();
    } else {
        closeDropdown();
    }
}

function attachCheckboxListeners() {
    const checkboxes = document.querySelectorAll('#companyCheckboxes input[type="checkbox"]');
    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', updateInitialCompanies);
    });
}

function updateInitialCompanies() {
    const initialCompanies = document.getElementById('initialCompanies');
    const selectedCompanies = Array.from(
        document.querySelectorAll('#companyCheckboxes input[type="checkbox"]:checked')
    ).map(checkbox => {
        const label = checkbox.parentElement.querySelector('label');
        return label ? label.textContent.replace(/^\d+\)\s*/, '').trim() : '';
    });

    const maxLength = 19;
    if (selectedCompanies.length === 0) {
        initialCompanies.innerHTML = 'Отсутствуют';
    }
    else {
        let displayText = selectedCompanies.slice(0, 2).join(', ');
        if (displayText.length > maxLength) {
            displayText = displayText.slice(0, maxLength - 3) + '...';
        }
        initialCompanies.textContent = displayText;
    }
}


function closeDropdown() {
    const initialCompanies = document.getElementById('initialCompanies');
    const companyDropdown = document.getElementById('companyDropdown');

    initialCompanies.style.display = 'inline';
    companyDropdown.style.display = 'none';

    document.removeEventListener('click', closeDropdown);
}

document.addEventListener('click', function(event) {
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

document.addEventListener('mousedown', (event) => {
    const roleSelect = document.getElementById('roleSelect');
    const roleDisplay = document.getElementById('roleDisplay');

    if (
        roleSelect.style.display === 'inline-block' &&
        !roleSelect.contains(event.target) &&
        !event.target.classList.contains('bi-pencil')
    ) {
        roleDisplay.innerText = roleSelect.options[roleSelect.selectedIndex].textContent;
        roleDisplay.style.display = 'inline';
        roleSelect.style.display = 'none';
    }
});

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

document.addEventListener('mousedown', (event) => {
    const userNameInput = document.getElementById('userNameInput');
    const surnameNameInput = document.getElementById('surnameNameInput');
    const userModalLabel = document.getElementById('userModalLabel');
    const surnameModalLabel = document.getElementById('surnameModalLabel');
    if (
        userNameInput.style.display === 'inline-block' &&
        !userNameInput.contains(event.target) &&
        !surnameNameInput.contains(event.target)
    ) {
        userModalLabel.innerText = userNameInput.value;
        surnameModalLabel.innerText = surnameNameInput.value;
        userModalLabel.style.display = 'block';
        surnameModalLabel.style.display = 'block';
        userNameInput.style.display = 'none';
        surnameNameInput.style.display = 'none';
    }
});

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

document.addEventListener('mousedown', (event) => {
    const birthdayInput = document.getElementById("birthday-input");
    const birthdayDisplay = document.getElementById("user-birthday");

    if (
        birthdayInput.style.display === 'inline-block' &&
        !birthdayInput.contains(event.target) &&
        !event.target.classList.contains('bi-pencil')
    ) {
        const dateParts = birthdayInput.value.split('-');
        birthdayDisplay.innerText = `${dateParts[1]}.${dateParts[2]}.${dateParts[0]}`;
        birthdayDisplay.style.display = 'inline';
        birthdayInput.style.display = 'none';
    }
});

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