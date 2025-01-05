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