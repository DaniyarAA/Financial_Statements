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

async function filterTasks() {
    const companyId = document.getElementById('companySelect').value;
    const userId = document.getElementById('userSelect').value;

    const queryParams = new URLSearchParams({
        companyId: companyId || '',
        userId: userId || ''
    });

    try {
        const response = await fetch(`/filterTasks?${queryParams.toString()}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader]: csrfToken
            }
        });

        if (!response.ok) throw new Error('Failed to fetch tasks');
        const tasks = await response.json();
        updateTaskList(tasks);
    } catch (error) {
        console.error(error);
        alert('Ошибка при загрузке задач');
    }
}

function updateTaskList(tasks) {
    const taskList = document.getElementById('taskList');
    taskList.innerHTML = '';

    if (tasks.length === 0) {
        taskList.innerHTML = '<span class="ms-3">Список задач пуст</span>';
        return;
    }

    tasks.forEach(task => {
        const taskItem = `
            <div class="task-item task-div">
                <div class="task-company-document">
                    <div class="task-id"><span>#${task.id}.</span></div>
                    <div class="company-name-document-type">
                        <div class="task-name">${task.company?.name || ''}</div>
                        <div class="task-document">${task.documentTypeName || ''}</div>
                    </div>
                </div>
                <div class="task-details">
                    <span class="task-date">${task.endDate || ''}</span>
                </div>
            </div>
         
        `;
        taskList.innerHTML += taskItem;
    });
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
    window.location.href = `${window.location.pathname}?${urlParams}`;
}