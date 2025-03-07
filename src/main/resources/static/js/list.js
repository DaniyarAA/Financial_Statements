document.addEventListener("DOMContentLoaded", function () {
    const urlParams = new URLSearchParams(window.location.search);
    const taskId = urlParams.get('id');
    if (taskId) {
        window.history.replaceState({}, '', window.location.pathname);
        const taskButton = document.querySelector(`[data-task-id="${taskId}"]`);
        if (taskButton) {
            showTaskDetails(taskButton);
        } else {
            console.error("Кнопка с указанным ID не найдена.");
        }
    }
});

function showTaskDetails(button) {
    const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
    document.getElementById('task-details').style.display = 'block';


    document.getElementById('document-type').textContent = button.getAttribute("data-document-type");
    document.getElementById('company-name').textContent = button.getAttribute("data-company-name");
    document.getElementById('company-inn').textContent = button.getAttribute("data-company-inn");
    // document.getElementById('date-range').textContent = `${button.getAttribute("data-start-date")} - ${button.getAttribute("data-end-date")}`;
    document.getElementById('amount').textContent = button.getAttribute("data-amount") + ' сом';
    const amount = button.getAttribute("data-amount");
    const amountInput = document.getElementById('amount-input');
    amountInput.value = formatAmount(amount);
    document.getElementById('amount').textContent = formatAmount(amount);
    amountInput.addEventListener('input', function () {
        this.value = this.value.replace(/[^0-9.]/g, '');
        if ((this.value.match(/\./g) || []).length > 1) {
            this.value = this.value.slice(0, -1);
        }
    });


    document.getElementById('filePath').textContent = button.getAttribute("data-file-path");
    document.getElementById('status').textContent = button.getAttribute("data-status");
    document.getElementById('description').value = button.getAttribute("data-description");
    document.getElementById('date-range-start-input').value = button.getAttribute("data-start-date");
    document.getElementById('date-range-end-input').value = button.getAttribute("data-end-date");

    const downloadLink = document.getElementById("download-task-file");
    const taskPath = button.getAttribute("data-encoded-file-path");
    const companyId = button.getAttribute("data-company-id");
    if (taskPath && companyId){
        downloadLink.href = `/api/files/download/${companyId}/${taskPath}`;
    }



    const statusIndicator = document.getElementById('status-indicator');
    const statusSelect = document.getElementById('status-select');
    statusIndicator.style.backgroundColor = button.getAttribute("data-status") === "Сдан" ? '#15C24E' : '#C20B18';
    document.getElementById('task-details').style.display = 'block';
    const taskDetails = document.getElementById('task-details');
    if (taskDetails) {
        taskDetails.style.width = '33%';
        taskDetails.border = '1px solid #dee2e6'
    }

    const usersDisplay = document.getElementById('users-display');
    const users = button.getAttribute("data-users");
    const parsedUsers = users ? JSON.parse(users) : [];
    const companyUsers = button.getAttribute("data-company-users");
    console.log(companyUsers)
    const parsedCompanyUsers = companyUsers ? JSON.parse(companyUsers) : [];
    const currentStatus = button.getAttribute("data-status");
    statusSelect.innerHTML = "";

    taskStatusDtos.forEach(status => {
        const option = document.createElement("option");
        option.value = status.id;
        option.textContent = status.name;
        console.log(status.name)
        console.log(currentStatus)
        if (status.name === currentStatus) {
            console.log("Зашел сюда")
            option.selected = true;
        }
        statusSelect.append(option);
    });

    usersDisplay.innerHTML = parsedUsers.length > 0
        ? parsedUsers.map(user => `${user.surname.charAt(0)}. ${user.name} `).join('')
        : 'Не задано';



    const initialUsers = document.getElementById("users-display");
    const maxLength = 30;
    let userNames = parsedUsers.map(user => `${user.surname.charAt(0)}. ${user.name}`);

    usersDisplay.innerHTML = userNames.length > 0 ? userNames.join(", ") : "Не задано";

    let displayText = userNames.slice(0, 2).join(", ");
    if (displayText.length > maxLength) {
        displayText = displayText.slice(0, maxLength - 3) + "...";
    } else if (userNames.length === 0) {
        displayText = "Не задано";
    }

    initialUsers.innerHTML = displayText;


    const userCheckboxes = document.getElementById("users-checkboxes");
    userCheckboxes.innerHTML = "";
    const sortedUsers = parsedCompanyUsers.sort((a, b) => {
        const aChecked = parsedUsers.some(userTask => userTask.id === a.id);
        const bChecked = parsedUsers.some(userTask => userTask.id === b.id);
        return bChecked - aChecked;
    });
    console.log(sortedUsers)
    console.log(parsedUsers)
    console.log(parsedCompanyUsers)

    sortedUsers.forEach((user, index) => {
        const checkbox = document.createElement("input");
        checkbox.type = "checkbox";
        checkbox.value = user.id;
        checkbox.id = `user_${user.id}`;
        checkbox.name = "userIds";
        checkbox.checked = parsedUsers.some(userTask => userTask.id === user.id);

        const label = document.createElement("label");
        label.setAttribute("for", `user_${user.id}`);
        label.textContent = `${index + 1}) ${user.name} ${user.surname}`;

        const div = document.createElement("div");
        div.style.display = "flex";
        div.style.justifyContent = "space-between";
        div.style.alignItems = "center";

        div.append(label);
        div.append(checkbox);

        userCheckboxes.append(div);
    });

    const form = document.getElementById("task-edit-form");
    form.setAttribute("data-task-id", button.getAttribute("data-task-id"));
    form.removeEventListener("submit", handleFormSubmit);
    form.addEventListener("submit", handleFormSubmit);

    const usersSearchInput = document.getElementById("assigned-users-search");


    usersSearchInput.addEventListener("input", function () {
        const searchTerm = usersSearchInput.value.toLowerCase();

        Array.from(userCheckboxes.children).forEach(div => {
            const label = div.querySelector("label");
            if (label.textContent.toLowerCase().includes(searchTerm)) {
                div.style.display = "flex";
            } else {
                div.style.display = "none";
            }
        });
    });


    // function handleFormSubmit (event){
    //     event.preventDefault();
    //
    //     console.log("Форма отправляется");
    //
    //     const taskId = button.getAttribute("data-task-id");
    //     form.action = `tasks/edit/${taskId}`;
    //     const formData = new FormData(form);
    //
    //     fetch(form.action, {
    //         method: form.method,
    //         body: formData,
    //     })
    //         .then(response => response.json())
    //         .then(data => {
    //             showNotification("Успешно обновлено!", "green");
    //
    //             window.location.reload();
    //             console.log("Успешно:", data);
    //         })
    //         .catch(error => console.error("Ошибка:", error));
    // }












    function toggleDropdown(button) {
        const dropdown = button.nextElementSibling;
        if (dropdown.style.display === 'none' || dropdown.style.display === '') {
            dropdown.style.display = 'block';
        } else {
            dropdown.style.display = 'none';
        }
    }

    var dateFormat = "dd.mm.yy";
    var from = $("#from").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        dateFormat: dateFormat
    }).on("change", function () {
        to.datepicker("option", "minDate", getDate(this));
    });

    var to = $("#to").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        dateFormat: dateFormat
    }).on("change", function () {
        from.datepicker("option", "maxDate", getDate(this));
    });
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

function handleFormSubmit(event) {
    event.preventDefault();

    const form = event.target;
    const taskId = form.getAttribute("data-task-id");
    form.action = `tasks/edit/${taskId}`;
    const formData = new FormData(form);


    fetch(form.action, {
        method: form.method,
        body: formData,
    })
        .then(response => response.json())
        .then(data => {
            showNotification("Успешно обновлено!", "green");
            window.location.reload();
        })
        .catch(error => console.error("Ошибка:", error));
}

// function showTaskDetails(button) {
//     const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute("content");
//
//     const taskId = button.getAttribute("data-task-id");
//     const documentType = button.getAttribute("data-document-type");
//     const startDate = button.getAttribute("data-start-date");
//     const endDate = button.getAttribute("data-end-date");
//     const companyId = button.getAttribute("data-company-id");
//     const companyName = button.getAttribute("data-company-name");
//     const companyInn = button.getAttribute("data-company-inn");
//     const description = button.getAttribute("data-description");
//     const amount = button.getAttribute("data-amount");
//     const status = button.getAttribute("data-status");
//     const isCompleted = status === "Сдан";
//     const filePath = button.getAttribute("data-file-path");
//
//     const formattedStartDate = formatDate(startDate);
//     const formattedEndDate = formatDate(endDate);
//     const formattedAmount = formatAmount(amount);
//
//     const users = button.getAttribute("data-users");
//     const parsedUsers = users ? JSON.parse(users) : [];
//
//     console.log(parsedUsers);
//
//     const taskDetails = document.getElementById('task-details');
//     if (taskDetails) {
//         taskDetails.style.width = '30%';
//         taskDetails.border = '1px solid #dee2e6'
//     }
//
//     let statusOptions = '';
//     taskStatusDtos.forEach((statusDto) => {
//         const isSelected = statusDto.id == status ? 'selected' : '';
//         statusOptions += `<option value="${statusDto.id}" ${isSelected}>${statusDto.name}</option>`;
//     });
//
//     const statusIndicatorColor = isCompleted ? '#15C24E' : '#C20B18';
//
//     document.getElementById('task-details').style.display = 'block';
//
//
//
//     // Удалил модалку редактирования задачи
//     document.getElementById('task-content').innerHTML = `    `;
//
//
//
//
//
//     const usersDisplay = document.getElementById('users-display');
//     if (usersDisplay) {
//         if (parsedUsers.length > 0) {
//             usersDisplay.innerHTML = `
//             <div>
//                 ${parsedUsers
//                 .map(
//                     (user, index) => `
//                         <div style="display: inline-flex; align-items: center; margin-bottom: 5px; position: relative;">
//                             <p style="margin: 0; font-size: 14px;">${user.surname.charAt(0)}. ${user.name}</p>
//                             <button type="button" class="btn btn-link" data-index="${index}" style="padding: 0; margin-left: 8px; vertical-align: middle;">
//                                 <img alt="Edit pen" src="/images/edit-pen.png" style="width: 20px; height: 20px; vertical-align: middle;">
//                             </button>
//                             <div class="dropdown-menu" style="display: none; position: absolute; top: 100%; left: 0; background: white; border: 1px solid #ccc; border-radius: 4px; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);">
//                                 <ul style="list-style: none; margin: 0; padding: 5px 10px;">
//                                     <li>
//                                         <label>
//                                             <input type="checkbox" name="option1"> Lorem ipsum.
//                                         </label>
//                                     </li>
//                                     <li>
//                                         <label>
//                                             <input type="checkbox" name="option2"> Lorem ipsum dolor.
//                                         </label>
//                                     </li>
//                                     <li>
//                                         <label>
//                                             <input type="checkbox" name="option3"> Lorem ipsum dolor sit.
//                                         </label>
//                                     </li>
//                                 </ul>
//                             </div>
//                         </div>
//                         `
//                 )
//                 .join('')}
//             </div>
//         `;
//             document.querySelectorAll('.btn.btn-link').forEach(button => {
//                 button.addEventListener('click', function () {
//                     toggleDropdown(button);
//                 });
//             });
//         } else {
//             usersDisplay.innerHTML = '<p>Не задано</p>';
//         }
//     } else {
//         console.error('Element with id "users-display" not found in the DOM.');
//     }
//
//     function toggleDropdown(button) {
//         const dropdown = button.nextElementSibling;
//         if (dropdown.style.display === 'none' || dropdown.style.display === '') {
//             dropdown.style.display = 'block';
//         } else {
//             dropdown.style.display = 'none';
//         }
//     }
//
//     var dateFormat = "dd.mm.yy";
//     var from = $("#from").datepicker({
//         defaultDate: "+1w",
//         changeMonth: true,
//         numberOfMonths: 1,
//         dateFormat: dateFormat
//     }).on("change", function () {
//         to.datepicker("option", "minDate", getDate(this));
//     });
//
//     var to = $("#to").datepicker({
//         defaultDate: "+1w",
//         changeMonth: true,
//         numberOfMonths: 1,
//         dateFormat: dateFormat
//     }).on("change", function () {
//         from.datepicker("option", "maxDate", getDate(this));
//     });
// }
//
// function handleFileUpload(event) {
//     const fileInput = event.target;
//     const file = fileInput.files[0];
//     const fileDisplay = document.querySelector('.file-display a');
//     const fileDisplayText = document.querySelector('.file-display p');
//
//     if (file) {
//         const fileName = file.name;
//
//         if (fileDisplay) {
//             fileDisplay.style.display = 'none';
//         }
//
//         if (!fileDisplayText) {
//             const newFileDisplayText = document.createElement('p');
//             newFileDisplayText.textContent = fileName;
//             newFileDisplayText.style.margin = '10px 0';
//             fileInput.parentElement.insertBefore(newFileDisplayText, fileInput);
//         } else {
//             fileDisplayText.textContent = fileName;
//         }
//     }
// }
//
// function formatDate(dateString) {
//     const [year, month, day] = dateString.split("-");
//     return `${day}.${month}.${year}`;
// }
//
function formatAmount(amount) {
    if (!amount || amount === "Не задано") {
        return "Не задано";
    }
    return parseFloat(amount.replace(/,/g, '')).toFixed(2);
}
//
// function editAmount() {
//     document.getElementById('amount-display').style.display = 'none';
//     document.getElementById('amount-input').style.display = 'block';
//
//     const amountInput = document.getElementById('amount');
//     const form = document.getElementById('task-edit-form');
//
//     amountInput.addEventListener('input', validateAmount);
//
//     function validateAmount() {
//         const errorMessage = document.getElementById('amount-error');
//         const value = amountInput.value.trim();
//
//         if (!value || isNaN(value) || Number(value) <= 0) {
//             if (!errorMessage) {
//                 const error = document.createElement('p');
//                 error.id = 'amount-error';
//                 error.textContent = 'Введите положительное число.';
//                 error.style.color = 'red';
//                 error.style.fontSize = '14px';
//                 error.style.marginTop = '5px';
//                 amountInput.parentNode.appendChild(error);
//             }
//             form.querySelector('button[type="submit"]').disabled = true;
//         } else {
//             if (errorMessage) errorMessage.remove();
//             form.querySelector('button[type="submit"]').disabled = false;
//         }
//     }
// }
//
// function cancelEditAmount() {
//     document.getElementById('amount-display').style.display = 'block';
//     document.getElementById('amount-input').style.display = 'none';
//
//     const errorMessage = document.getElementById('amount-error');
//     if (errorMessage) errorMessage.remove();
//     const form = document.getElementById('task-edit-form');
//     form.querySelector('button[type="submit"]').disabled = false;
// }
//
// function editStatus() {
//     document.getElementById('status-display').style.display = 'none';
//     document.getElementById('status-input').style.display = 'block';
// }
//
// function cancelEditStatus() {
//     document.getElementById('status-display').style.display = 'block';
//     document.getElementById('status-input').style.display = 'none';
// }
//
// function editDate() {
//     document.getElementById('date-display').style.display = 'none';
//     document.getElementById('date-input').style.display = 'block';
// }
//
// function cancelEditDate() {
//     document.getElementById('date-display').style.display = 'block';
//     document.getElementById('date-input').style.display = 'none';
// }
//
// function editFile() {
//     document.getElementById('file-display').style.display = 'none';
//     document.getElementById('file-input').style.display = 'flex';
// }
//
// function cancelEditFile() {
//     document.getElementById('file-display').style.display = 'flex';
//     document.getElementById('file-input').style.display = 'none';
// }
//
// document.addEventListener("DOMContentLoaded", function () {
//     const paginationContainer = document.querySelector('.pagination-container');
//
//     if (paginationContainer) {
//         paginationContainer.addEventListener('click', function (event) {
//             const target = event.target.closest('.pagination-link');
//             if (target) {
//                 const page = target.getAttribute('data-page');
//                 if (page !== null) {
//                     navigateToPage(page);
//                 }
//             }
//         });
//     }
//
//     function navigateToPage(page) {
//         const searchParams = new URLSearchParams(window.location.search);
//         searchParams.set("page", page);
//         window.location.href = `${window.location.pathname}?${searchParams.toString()}`;
//     }
// });
// function setupNavigationButtons() {
//     const yearMonthColumns = document.querySelectorAll(".year-month-th");
//
//     if (yearMonthColumns.length >= 1) {
//         const urlParams = new URLSearchParams(window.location.search);
//         const currentYearMonth = urlParams.get("yearMonth") || getCurrentMonth();
//
//         const firstColumn = yearMonthColumns[0];
//         if (!firstColumn.querySelector(".btn-nav-img-prev")) {
//             const prevButtonImage = document.createElement("img");
//             prevButtonImage.src = "/images/prev-month.png";
//             prevButtonImage.alt = "Previous Month";
//             prevButtonImage.classList.add("btn-nav-img", "btn-nav-img-prev");
//             prevButtonImage.style.position = "absolute";
//             prevButtonImage.style.left = "5px";
//             prevButtonImage.style.top = "0px";
//             prevButtonImage.style.cursor = "pointer";
//             prevButtonImage.style.width = "35px";
//             prevButtonImage.style.height = "35px";
//
//             const previousYearMonth = getAdjacentYearMonth(currentYearMonth, availableYearMonths, -1);
//             if (!previousYearMonth) {
//                 prevButtonImage.style.filter = "grayscale(100%)";
//                 prevButtonImage.style.cursor = "not-allowed";
//                 prevButtonImage.classList.add("disabled");
//             } else {
//                 prevButtonImage.addEventListener("click", () => {
//                     window.location.href = updateURLParameter("yearMonth", previousYearMonth);
//                 });
//             }
//
//             firstColumn.style.position = "relative";
//             firstColumn.appendChild(prevButtonImage);
//         }
//
//         const lastColumn = yearMonthColumns[yearMonthColumns.length - 1];
//         if (!lastColumn.querySelector(".btn-nav-img-next")) {
//             const nextButtonImage = document.createElement("img");
//             nextButtonImage.src = "/images/next-month.png";
//             nextButtonImage.alt = "Next Month";
//             nextButtonImage.classList.add("btn-nav-img", "btn-nav-img-next");
//             nextButtonImage.style.position = "absolute";
//             nextButtonImage.style.right = "5px";
//             nextButtonImage.style.top = "0px";
//             nextButtonImage.style.cursor = "pointer";
//             nextButtonImage.style.width = "35px";
//             nextButtonImage.style.height = "35px";
//
//             const nextYearMonth = getAdjacentYearMonth(currentYearMonth, availableYearMonths, 1);
//             if (!nextYearMonth) {
//                 nextButtonImage.style.filter = "grayscale(100%)";
//                 nextButtonImage.style.cursor = "not-allowed";
//                 nextButtonImage.classList.add("disabled");
//             } else {
//                 nextButtonImage.addEventListener("click", () => {
//                     window.location.href = updateURLParameter("yearMonth", nextYearMonth);
//                 });
//             }
//
//             lastColumn.style.position = "relative";
//             lastColumn.appendChild(nextButtonImage);
//         }
//     }
//
//     function getAdjacentYearMonth(current, yearMonths, delta) {
//         const currentIndex = yearMonths.indexOf(current);
//         const newIndex = currentIndex + delta;
//
//         if (newIndex >= 0 && newIndex < yearMonths.length) {
//             return yearMonths[newIndex];
//         }
//
//         return null;
//     }
//
//     function updateURLParameter(key, value) {
//         const searchParams = new URLSearchParams(window.location.search);
//         searchParams.set(key, value);
//         return `${window.location.pathname}?${searchParams.toString()}`;
//     }
//
//     function getCurrentMonth() {
//         const date = new Date();
//         return `${String(date.getMonth() + 1).padStart(2, "0")}.${date.getFullYear()}`;
//     }
// }
//
// document.addEventListener("DOMContentLoaded", setupNavigationButtons);
//
//
// function getDate(element) {
//     var date;
//     try {
//         date = $.datepicker.parseDate(dateFormat, element.value);
//     } catch (error) {
//         date = null;
//     }
//     return date;
// }
//
// function addCollapseButtonToTaskDetails() {
//     const taskDetailsHeader = document.querySelector('.task-details-header');
//
//     if (!taskDetailsHeader.querySelector('.btn-collapse-task-details')) {
//         const collapseButton = document.createElement('button');
//         collapseButton.type = 'button';
//         collapseButton.className = 'btn-collapse-task-details';
//         collapseButton.style.cssText = `
//             background: none;
//             border: none;
//             position: absolute;
//             top: 10px;
//             right: 10px;
//             cursor: pointer;
//         `;
//
//         collapseButton.innerHTML = `<img src="/images/company-arrow.png" alt="Collapse" style="width: 24px; height: 24px;">`;
//
//         collapseButton.addEventListener('click', () => {
//             const taskDetails = document.getElementById('task-details');
//             if (taskDetails) {
//                 taskDetails.style.width = '0';
//                 taskDetails.overflow = 'hidden';
//                 taskDetails.padding = '0';
//                 taskDetails.transition = 'width 0.3s ease, padding 0.3s ease';
//             }
//         });
//
//         taskDetailsHeader.appendChild(collapseButton);
//     }
// }
// document.addEventListener('DOMContentLoaded', () => {
//     addCollapseButtonToTaskDetails();
// });
//
// function addCollapseButtonToCreateTask() {
//     const taskCreateHeader = document.querySelector('.task-create-header');
//
//     if (!taskCreateHeader.querySelector('.btn-collapse-task-create')) {
//         const collapseButton = document.createElement('button');
//         collapseButton.type = 'button';
//         collapseButton.className = 'btn-collapse-task-create';
//         collapseButton.style.cssText = `
//             background: none;
//             border: none;
//             position: absolute;
//             top: 10px;
//             right: 10px;
//             cursor: pointer;
//         `;
//
//         collapseButton.innerHTML = `<img src="/images/company-arrow.png" alt="Collapse" style="width: 24px; height: 24px;">`;
//
//         collapseButton.addEventListener('click', () => {
//             const taskCreate = document.getElementById('task-create');
//             if (taskCreate) {
//                 taskCreate.style.width = '0';
//                 taskCreate.overflow = 'hidden';
//                 taskCreate.padding = '0';
//                 taskCreate.transition = 'width 0.3s ease, padding 0.3s ease';
//             }
//         });
//
//         taskCreateHeader.appendChild(collapseButton);
//     }
// }
// document.addEventListener('DOMContentLoaded', () => {
//     addCollapseButtonToCreateTask();
// });
//
// function addCreateTaskButton() {
//     const addTaskButton = document.createElement('button');
//     addTaskButton.className = 'btn-create-task';
//     addTaskButton.style.cssText = `
//         background: none;
//             border: none;
//             position: absolute;
//             top: 2px;
//             right: 34px;
//             cursor: pointer;
//     `;
//
//     addTaskButton.innerHTML = `<img src="/images/add.png" alt="Collapse" style="width: 40px; height: 40px;">`;
//
//     addTaskButton.addEventListener('click', () => {
//         toggleCreateTaskForm();
//     });
//
//     document.body.appendChild(addTaskButton);
// }
//
// document.addEventListener('DOMContentLoaded', () => {
//     addCreateTaskButton();
// });
//
//
// function toggleCreateTaskForm() {
//     const createTaskForm = document.getElementById('task-create');
//     createTaskForm.style.width = '30%';
//     createTaskForm.style.transition = 'width 0.3s ease, padding 0.3s ease';
// }
//
// function showSecondPage() {
//     const formPage1 = document.getElementById('formPage1');
//     const formPage2 = document.getElementById('formPage2');
//
//     formPage1.classList.add('slide-out-left');
//     formPage1.addEventListener('animationend', () => {
//         formPage1.style.display = 'none';
//         formPage1.classList.remove('slide-out-left');
//
//         formPage2.style.display = 'block';
//         formPage2.classList.add('slide-in-right');
//         formPage2.addEventListener('animationend', () => {
//             formPage2.classList.remove('slide-in-right');
//         }, { once: true });
//     }, { once: true });
// }
//
// function showFirstPage() {
//     const formPage1 = document.getElementById('formPage1');
//     const formPage2 = document.getElementById('formPage2');
//
//     formPage2.classList.add('slide-out-right');
//     formPage2.addEventListener('animationend', () => {
//         formPage2.style.display = 'none';
//         formPage2.classList.remove('slide-out-right');
//
//         formPage1.style.display = 'block';
//         formPage1.classList.add('slide-in-left');
//         formPage1.addEventListener('animationend', () => {
//             formPage1.classList.remove('slide-in-left');
//         }, { once: true });
//     }, { once: true });
// }
//
// document.addEventListener("DOMContentLoaded", function() {
//     const openModal = document.getElementById('openModal').value;
//     if (openModal === 'true') {
//         toggleCreateTaskForm()
//     }
// });
//
//
// document.addEventListener("DOMContentLoaded", function () {
//     // const form = document.getElementById("task-details");
//
//     // form.addEventListener("submit", function (e) {
//     //     e.preventDefault();
//     //
//     //     const editForm = document.getElementById("task-edit-form");
//     //     const formData = new FormData(editForm);
//     //     const actionUrl = editForm.getAttribute("action");
//     //
//     //     const existingAlert = document.getElementById("alertMessage");
//     //     if (existingAlert) {
//     //         existingAlert.remove();
//     //     }
//     //
//     //     fetch(actionUrl, {
//     //         method: "POST",
//     //         body: formData,
//     //         csrfToken: csrfToken
//     //
//     //     })
//     //         .then(response => {
//     //             if (!response.ok) {
//     //                 return response.json().then(err => Promise.reject(err));
//     //             }
//     //             return response.json();
//     //         })
//     //         .then(data => {
//     //             showAlert(data.success || "Задача успешно обновлена!", "success");
//     //         })
//     //         .catch(error => {
//     //             showAlert(error.error || "Возникла ошибка.", "error");
//     //         });
//     // });
//
//     // function showAlert(message, type) {
//     //     const alertDiv = document.createElement("div");
//     //     alertDiv.id = "alertMessage";
//     //     alertDiv.textContent = message;
//     //     alertDiv.style.position = "absolute";
//     //     alertDiv.style.top = "20px";
//     //     alertDiv.style.right = "20px";
//     //     alertDiv.style.padding = "15px 20px";
//     //     alertDiv.style.borderRadius = "8px";
//     //     alertDiv.style.color = "#fff";
//     //     alertDiv.style.fontSize = "14px";
//     //     alertDiv.style.boxShadow = "0px 2px 5px rgba(0, 0, 0, 0.2)";
//     //     alertDiv.style.zIndex = "1000";
//     //
//     //     if (type === "success") {
//     //         alertDiv.style.backgroundColor = "#28a745";
//     //     } else {
//     //         alertDiv.style.backgroundColor = "#dc3545";
//     //     }
//     //
//     //     document.body.appendChild(alertDiv);
//     //
//     //     setTimeout(() => {
//     //         alertDiv.remove();
//     //         if (type === "success") {
//     //             window.location.reload();
//     //         }
//     //     }, 2000);
//     // }
//     const sidebar = document.querySelector('.company-table');
//     const taskListWrapper = document.querySelector('.tasks-table');
//     if (!taskListWrapper){
//         console.log("Не нашел")
//     }
//
//     if (sidebar && taskListWrapper) {
//         sidebar.addEventListener('scroll', () => {
//             taskListWrapper.scrollTop = sidebar.scrollTop;
//             console.log("HHHH")
//         });
//
//         taskListWrapper.addEventListener('scroll', () => {
//             console.log("hhh")
//             sidebar.scrollTop = taskListWrapper.scrollTop;
//         });
//     } else {
//         console.error('Ошибка синхронизации скролла');
//     }
// });
//
// document.addEventListener("DOMContentLoaded", function () {
//     const createTaskForm = document.getElementById("form-create");
//
//     if (createTaskForm) {
//         createTaskForm.addEventListener("submit", function (e) {
//             e.preventDefault();
//
//             const formData = new FormData(createTaskForm);
//             const actionUrl = createTaskForm.getAttribute("action");
//
//             const existingAlert = document.getElementById("alertMessage");
//             if (existingAlert) {
//                 existingAlert.remove();
//             }
//
//             fetch(actionUrl, {
//                 method: "POST",
//                 body: formData,
//             })
//                 .then((response) => {
//                     if (!response.ok) {
//                         return response.json().then((err) => Promise.reject(err));
//                     }
//                     return response.json();
//                 })
//                 .then((data) => {
//                     showAlert(data.success || "Задача успешно создана!", "success");
//                 })
//                 .catch((error) => {
//                     showAlert(error.error || "Возникла ошибка при создании задачи.", "error");
//                 });
//         });
//     }
//
//     function showAlert(message, type) {
//         const alertDiv = document.createElement("div");
//         alertDiv.id = "alertMessage";
//         alertDiv.textContent = message;
//         alertDiv.style.position = "absolute";
//         alertDiv.style.top = "20px";
//         alertDiv.style.right = "20px";
//         alertDiv.style.padding = "15px 20px";
//         alertDiv.style.borderRadius = "8px";
//         alertDiv.style.color = "#fff";
//         alertDiv.style.fontSize = "14px";
//         alertDiv.style.boxShadow = "0px 2px 5px rgba(0, 0, 0, 0.2)";
//         alertDiv.style.zIndex = "1000";
//
//         if (type === "success") {
//             alertDiv.style.backgroundColor = "#28a745";
//         } else {
//             alertDiv.style.backgroundColor = "#dc3545";
//         }
//
//         document.body.appendChild(alertDiv);
//
//         setTimeout(() => {
//             alertDiv.remove();
//             if (type === "success") {
//                 window.location.reload();
//             }
//         }, 2000);
//     }
// });
//
//
// function openCompanyPopup() {
//     const modal = document.getElementById("company-modal");
//     const dropdown = document.getElementById("modal-company-dropdown");
//     modal.style.display = "block";
//
//     populateModalDropdown(companyDtos);
// }
//
// function closeCompanyPopup() {
//     const modal = document.getElementById("company-modal");
//     modal.style.display = "none";
// }
//
// function populateModalDropdown(companies) {
//     const dropdown = document.getElementById("modal-company-dropdown");
//     dropdown.innerHTML = "";
//
//     companies.forEach(company => {
//         const li = document.createElement("li");
//         li.textContent = company.name;
//         li.className = "dropdown-item";
//         li.dataset.companyId = company.id;
//
//         li.addEventListener("click", () => {
//             selectCompanyFromModal(company);
//         });
//
//         dropdown.appendChild(li);
//     });
// }
//
// function updateModalDropdown() {
//     const searchValue = document.getElementById("company-modal-search").value.toLowerCase();
//     const filteredCompanies = companyDtos.filter(company =>
//         company.name.toLowerCase().includes(searchValue)
//     );
//
//     populateModalDropdown(filteredCompanies);
// }
//
// function selectCompanyFromModal(company) {
//     const searchInput = document.getElementById("company-search");
//     const hiddenInput = document.getElementById("company-id");
//
//     searchInput.value = company.name;
//     hiddenInput.value = company.id;
//
//     onCompanySelected(company.id);
//
//     closeCompanyPopup();
// }
//
//
// document.addEventListener("click", event => {
//     const modal = document.getElementById("company-modal");
//     if (event.target === modal) {
//         closeCompanyPopup();
//     }
// });
//
// let selectedCompanyUsers = [];
//
// function openUserPopup() {
//     const modal = document.getElementById("user-modal");
//     modal.style.display = "block";
//
//     populateUserModalDropdown(selectedCompanyUsers);
// }
//
// // Close User Popup
// function closeUserPopup() {
//     const modal = document.getElementById("user-modal");
//     modal.style.display = "none";
// }
//
// // Populate User Dropdown
// function populateUserModalDropdown(users) {
//     const dropdown = document.getElementById("modal-user-dropdown");
//     dropdown.innerHTML = "";
//
//     users.forEach(user => {
//         const li = document.createElement("li");
//         li.textContent = `${user.surname} ${user.name}`;
//         li.className = "dropdown-item";
//         li.dataset.userId = user.id;
//
//         li.addEventListener("click", () => {
//             selectUserFromModal(user);
//         });
//
//         dropdown.appendChild(li);
//     });
// }
//
// function updateUserModalDropdown() {
//     const searchValue = document.getElementById("user-modal-search").value.toLowerCase();
//     const filteredUsers = selectedCompanyUsers.filter(user =>
//         `${user.surname} ${user.name}`.toLowerCase().includes(searchValue)
//     );
//
//     populateUserModalDropdown(filteredUsers);
// }
//
// function selectUserFromModal(user) {
//     const searchInput = document.getElementById("user-search");
//     const hiddenInput = document.getElementById("user-id");
//
//     searchInput.value = `${user.surname} ${user.name}`;
//     hiddenInput.value = user.id;
//
//     closeUserPopup();
// }
//
// function onCompanySelected(companyId) {
//     const company = companyDtos.find(c => c.id === companyId);
//     selectedCompanyUsers = company ? company.users : [];
// }

function toggleAmountEdit() {
    const amountDisplay = document.getElementById('amount');
    const amountInput = document.getElementById('amount-input');

    if (amountInput.style.display === 'inline') {
        const inputValue = amountInput.value.trim();
        amountDisplay.innerText = inputValue ? inputValue + " сом" : "Не задано";
        amountDisplay.dataset.value = inputValue;
    } else {
        amountInput.value = amountDisplay.innerText.replace(/[^0-9.]/g, '').trim();
        amountInput.focus();
    }

    amountInput.style.display = amountInput.style.display === 'inline' ? 'none' : 'inline';
    amountDisplay.style.display = amountDisplay.style.display === 'inline' ? 'none' : 'inline';
}

function toggleFileEdit() {
    const fileInput = document.getElementById('file');
    const fileDisplay = document.getElementById('filePath');
    if (fileInput.style.display === "inline"){
        fileInput.style.display = "none";
        fileDisplay.style.display = "inline";
    } else {
        fileInput.style.display = "inline";
        fileDisplay.style.display = "none";
    }

}


function toggleStatusEdit() {
    const statusDisplay = document.getElementById('status');
    const statusSelect = document.getElementById('status-select');
    if (statusSelect.style.display === 'none') {
        statusDisplay.style.display = 'none';
        statusSelect.style.display = 'inline';
    } else {
        const selectedOption = statusSelect.options[statusSelect.selectedIndex];
        statusDisplay.innerText = selectedOption ? selectedOption.textContent : 'Отсутствует';
        statusDisplay.style.display = 'inline';
        statusSelect.style.display = 'none';
    }
}


function toggleUsersEdit() {
    const initialUsers = document.getElementById('users-display');
    const usersDropdown = document.getElementById('assigned-users-dropdown');
    if (usersDropdown.style.display === 'none') {
        initialUsers.style.display = 'none';
        usersDropdown.style.display = 'inline-block';
        attachCheckboxListeners();
    } else {
        closeUsersDropdown();
    }
}

function attachCheckboxListeners() {
    const checkboxes = document.querySelectorAll('#users-checkboxes input[type="checkbox"]');
    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', updateInitialUsers);
    });
}

function updateInitialUsers() {
    const initialUsers = document.getElementById('users-display');
    const selectedUsers = Array.from(
        document.querySelectorAll('#users-checkboxes input[type="checkbox"]:checked')
    ).map(checkbox => {
        const label = checkbox.parentElement.querySelector('label');
        return label ? label.textContent.replace(/^\d+\)\s*/, '').trim() : '';
    });

    const maxLength = 19;
    if (selectedUsers.length === 0) {
        initialUsers.innerHTML = 'Не задано';
    }
    else {
        let displayText = selectedUsers.slice(0, 2).join(', ');
        if (displayText.length > maxLength) {
            displayText = displayText.slice(0, maxLength - 3) + '...';
        }
        initialUsers.textContent = displayText;
    }
}


function closeUsersDropdown() {
    const initialUsers = document.getElementById('users-display');
    const usersDropdown = document.getElementById('assigned-users-dropdown');

    initialUsers.style.display = 'inline-block';
    usersDropdown.style.display = 'none';

    document.removeEventListener('click', closeUsersDropdown);
}

document.addEventListener('click', function(event) {
    const usersDropdown = document.getElementById('assigned-users-dropdown');
    const editIcon = document.getElementById('edit-users-icon');

    if (!usersDropdown.contains(event.target) && event.target !== editIcon) {
        closeUsersDropdown();
    }
});