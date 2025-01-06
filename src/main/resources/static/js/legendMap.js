const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');
const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

function openModal() {
    const modal = document.getElementById('legendMapModal');
    modal.style.display = 'flex';
    setTimeout(() => modal.classList.add('show'), 10);

    modal.addEventListener('click', (event) => {
        if (event.target === modal) {
            closeModal();
        }
    });
}

function closeModal() {
    const modal = document.getElementById('legendMapModal');
    modal.classList.remove('show');
    setTimeout(() => modal.style.display = 'none', 300);
}




const sortState = {
    id: 'asc',
    endDate: 'asc',
    priority: 'asc'
};

function sortTasks(sortBy) {
    const currentOrder = sortState[sortBy];
    const newOrder = currentOrder === 'asc' ? 'desc' : 'asc';
    sortState[sortBy] = newOrder;
    const taskScroll = document.getElementById("taskScroll");
    const tasks = Array.from(taskScroll.querySelectorAll(".task-item"));

    tasks.sort((a, b) => {
        let valA = a.dataset[sortBy];
        let valB = b.dataset[sortBy];

        if (sortBy === "priority") {
            valA = valA ? parseInt(valA, 10) : 0;
            valB = valB ? parseInt(valB, 10) : 0;
        }
        if (sortBy === "id") {
            valA = parseInt(valA, 10);
            valB = parseInt(valB, 10);
        }

        if (sortBy === "endDate") {
            valA = new Date(valA);
            valB = new Date(valB);
        }

        if (valA < valB) return newOrder === "asc" ? -1 : 1;
        if (valA > valB) return newOrder === "asc" ? 1 : -1;
        return 0;
    });

    tasks.forEach((task) => taskScroll.appendChild(task));
}

function updateQueryParam(param, value) {
    const urlParams = new URLSearchParams(window.location.search);
    if (value === "") {
        urlParams.delete(param);
    } else {
        urlParams.set(param, value);
    }
    const queryString = urlParams.toString();
    window.location.href = queryString ? `${window.location.pathname}?${queryString}` : window.location.pathname;
}

function highlightSelected() {
    const urlParams = new URLSearchParams(window.location.search);
    const selectedCompanyId = urlParams.get('companyId');
    const selectedUserId = urlParams.get('userId');
    const companyListItems = document.querySelectorAll('#companiesListOnTasks li');
    const userListItems = document.querySelectorAll('#usersListOnTasks li');
    const companySearch = document.getElementById("companySearch");
    const userSearch = document.getElementById("userSearch");
    if(companyListItems){
        let selectedCompanyName = "Поиск компаний";
        companyListItems.forEach((item) => {
            item.classList.remove('selected');
            if (item.getAttribute('data-value') === selectedCompanyId) {
                item.classList.add('selected');
                selectedCompanyName = item.textContent.trim();
            }
        });
        companySearch.placeholder = selectedCompanyName;
    }
    if(userListItems){
        let selectedUserName = "Поиск пользователей";
        userListItems.forEach((item) => {
            item.classList.remove('selected');
            if (item.getAttribute('data-value') === selectedUserId) {
                item.classList.add('selected');
                selectedUserName = item.textContent.trim();
            }
        });
        userSearch.placeholder = selectedUserName;
    }
}
window.addEventListener('DOMContentLoaded', highlightSelected);


function searchCompanies(searchInputId) {
    const searchInput = document.getElementById(searchInputId).value.toLowerCase();
    const dropdown = document.getElementById('companiesListOnTasks');
    const listItems = dropdown.getElementsByTagName('li');
    dropdown.style.display = 'block';

    for (const item of listItems) {
        const text = item.textContent || item.innerText;
        item.style.display = text.toLowerCase().includes(searchInput) ? "" : "none";
    }
}


document.addEventListener('click', function (event) {
    const companiesSearchInput = document.getElementById('companySearch');
    const usersSearchInput = document.getElementById('userSearch');
    const companiesDropdown = document.getElementById('companiesListOnTasks');
    const usersDropdown = document.getElementById('usersListOnTasks');


    if (!companiesDropdown.contains(event.target) && event.target !== companiesSearchInput) {
        companiesDropdown.style.display = 'none';
    }
    if (!usersDropdown.contains(event.target) && event.target !== usersSearchInput) {
        usersDropdown.style.display = 'none';
    }
});


function openCompanyDropdownOnTasks(){
    const dropdown = document.getElementById('companiesListOnTasks');
    dropdown.style.display = 'block';

}

function openUserDropdownOnTasks(){
    const dropdown = document.getElementById('usersListOnTasks');
    dropdown.style.display = 'block';
}



function searchUsers() {
    const searchInput = document.getElementById('userSearch').value.toLowerCase();
    const dropdown = document.getElementById('usersListOnTasks');
    const listItems = dropdown.getElementsByTagName('li');

    dropdown.style.display = 'block';

    for (const item of listItems) {
        const text = item.textContent || item.innerText;
        item.style.display = text.toLowerCase().includes(searchInput) ? "" : "none";
    }
}