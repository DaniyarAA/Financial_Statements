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

document.addEventListener("DOMContentLoaded", function() {
    const savedViewMode = localStorage.getItem('viewMode');
    if (savedViewMode === 'tile') {
        switchToTileView();
    } else {
        switchToListView();
    }
});


document.addEventListener("DOMContentLoaded", function () {
    const userModal = document.getElementById("userModal");

    userModal.addEventListener("show.bs.modal", function (event) {
        const button = event.relatedTarget;
        const userId = button.getAttribute("data-user-id");

        fetch(`/admin/users/edit/` + userId)
            .then(response => response.json())
            .then(data => {
                const user = data.user;
                const companies = data.companies;
                const roles = data.roles;

                document.getElementById("userModalLabel").innerText = user.name;
                const birthday = new Date(user.birthday);
                document.getElementById("user-birthday").innerText = birthday.toLocaleDateString("ru-RU");
                document.getElementById("user-status").innerText = user.enabled ? "Активен" : "Неактивен";
                document.getElementById("notesInput").innerText = user.notes;

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
                    roleSelect.appendChild(option);
                });

                const initialCompanies = document.getElementById("initialCompanies");
                initialCompanies.innerHTML = user.companies.slice(0, 1).map(company => company.name).join(", ");
                if (user.companies.length > 1) {
                    initialCompanies.innerHTML += ", ...";
                } else if (user.companies.length === 0){
                    initialCompanies.innerHTML += "Отсутствуют"
                }

                const companyCheckboxes = document.getElementById("companyCheckboxes");
                companyCheckboxes.innerHTML = "";
                companies.forEach(company => {
                    const checkbox = document.createElement("input");
                    checkbox.type = "checkbox";
                    checkbox.value = company.id;
                    checkbox.id = `company_${company.id}`;
                    checkbox.checked = user.companies.some(userCompany => userCompany.id === company.id);

                    const label = document.createElement("label");
                    label.setAttribute("for", `company_${company.id}`);
                    label.textContent = company.name;

                    const div = document.createElement("div");
                    div.style.display = "flex";
                    div.style.justifyContent = "space-between";
                    div.style.alignItems = "center";

                    div.appendChild(label);
                    div.appendChild(checkbox);

                    companyCheckboxes.appendChild(div);
                });

            })
            .catch(error => console.error("Error loading user data:", error));
    });
});


function toggleCompanyEdit() {
    const initialCompanies = document.getElementById('initialCompanies');
    const companyDropdown = document.getElementById('companyDropdown');

    if (companyDropdown.style.display === 'none') {
        initialCompanies.style.display = 'none';
        companyDropdown.style.display = 'inline-block';
    } else {
        initialCompanies.style.display = 'inline';
        companyDropdown.style.display = 'none';
    }
}




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
