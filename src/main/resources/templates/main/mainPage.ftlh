<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>

    <div class="container p-3 main-container">
        <div class="main row">
            <div class="col-6">
                <div class="left-content row">
                    <div class="col-6 report-archive column">
                        <div class="reports col-6 main-content">

                            <div class="report-content">
                                <a href="#">
                                    <div class="report-header report-button">
                                        <p>СФОРМИРОВАТЬ ОТЧЕТ</p>
                                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="black"
                                             class="bi bi-lock report-icon" viewBox="0 0 16 16">
                                            <path fill-rule="evenodd"
                                                  d="M8 1a3 3 0 0 1 3 3v3h1a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h1V4a3 3 0 0 1 3-3zm0 1a2 2 0 0 0-2 2v3h4V4a2 2 0 0 0-2-2zM4 8a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V9a1 1 0 0 0-1-1H4z"/>
                                        </svg>
                                    </div>
                                </a>
                                <button type="button" class="button btn type-btn reports-btn" data-bs-toggle="modal"
                                        data-bs-target="#monthlyReportModal">
                                    ЕЖЕМЕСЯЧНЫЙ
                                </button>
                                <button type="button" class="button btn type-btn reports-btn " data-bs-toggle="modal"
                                        data-bs-target="#quarterlyReportModal">
                                    ЕЖЕКВАРТАЛЬНЫЙ
                                </button>
                                <button type="button" class="button btn type-btn reports-btn" data-bs-toggle="modal"
                                        data-bs-target="#yearlyReportModal">
                                    ГОДОВОЙ
                                </button>
                            </div>
                        </div>
                        <div class="archives col-6 main-content">
                            <div class="archive-header">
                                <p class="archive-header-text">АРХИВ</p>
                            </div>
                            <div class="archive-content">
                                <#assign hasAccess = false />
                                <#list userDto.role.authorities as auth>
                                    <#if auth.authority == "VIEW_ARCHIVE">
                                        <#assign hasAccess = true />
                                        <#break>
                                    </#if>
                                </#list>
                                <a href="${hasAccess?then('/archive/all', '/archive')}" class="btn type-btn">
                                    <img src="/images/archive.png" class="archive-image selectDisable" alt="archive">
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-6 company-calendar column">
                        <div class="companies col-6 main-content">
                            <#if canCreateCompany>
                                <a href="/company/all?sort=actual&openModal=true">
                                    <div class="company-button">
                                        <div class="button-text company-text">
                                            <p>СОЗДАТЬ НОВЫЙ<br>ИП/ОСОО</p>
                                        </div>
                                    </div>
                                </a>
                            </#if>
                            <a href="/company/all?sort=actual">
                                <div class="company-button">
                                    <div class="button-text company-text">
                                        <p>СПИСОК<br>КОМПАНИЙ</p>
                                    </div>
                                </div>
                            </a>
                        </div>
                        <div class="calendars col-6 main-content">
                            <div class="calendar-header">
                                <p>КАЛЕНДАРЬ</p>
                            </div>
                            <div id="divCal" class="calendar-content">

                            </div>
                            <input type="hidden" name="_csrf" value="${csrfToken.token}">

                        </div>
                    </div>
                </div>
            </div>

            <div class="col tasks">
                <div class="tasks-header">
                    <#if userDto.getRole().roleName =='SuperUser'>
                        <div class="select-for-task">
                            <select class="form-select w-50%" id="companySelect" onchange="filterTasks()">
                                <option value="">Выберите компанию</option>
                                <#list companies as company>
                                    <option value="${company.id}">${company.name}</option>
                                </#list>
                            </select>

                            <select class="form-select w-50%" id="userSelect" onchange="filterTasks()">
                                <option value="">Выберите пользователя</option>
                                <#list users as user>
                                    <option value="${user.id}">${user.name}</option>
                                </#list>
                            </select>
                        </div>
                    </#if>
                    <h3><a href="/tasks" class="btn type-submit ms-5">ЗАДАЧИ</a></h3>
                    <div class="task-actions">
                        <a href="#" class="btn type-btn help-task" onclick="openModal()">
                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor"
                                 class="bi bi-question-circle" viewBox="0 0 16 16">
                                <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                                <path d="M5.255 5.786a.237.237 0 0 0 .241.247h.825c.138 0 .248-.113.266-.25.09-.656.54-1.134 1.342-1.134.686 0 1.314.343 1.314 1.168 0 .635-.374.927-.965 1.371-.673.489-1.206 1.06-1.168 1.987l.003.217a.25.25 0 0 0 .25.246h.811a.25.25 0 0 0 .25-.25v-.105c0-.718.273-.927 1.01-1.486.609-.463 1.244-.977 1.244-2.056 0-1.511-1.276-2.241-2.673-2.241-1.267 0-2.655.59-2.75 2.286m1.557 5.763c0 .533.425.927 1.01.927.609 0 1.028-.394 1.028-.927 0-.552-.42-.94-1.029-.94-.584 0-1.009.388-1.009.94"/>
                            </svg>
                        </a>
                        <a href="/tasks?openModal=true" class="btn type-btn add-task">
                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" font-weight="bold"
                                 fill="currentColor" class="bi bi-plus-circle" viewBox="0 0 16 16">
                                <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                                <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                            </svg>
                        </a>
                    </div>
                </div>


                <div class="task-list" id="taskList">
                    <div class="tasks-scroll" >
                        <#if userDto.role.roleName == 'SuperUser'>
                            <#if tasks?has_content>
                                <#list tasks as task>
                                    <div class="task-item task-div">
                                        <div class="task-company-document">
                                            <div class="task-id">
                                         <span>
                                             <a href="?sort=<#if sort == 'desc'>asc<#else>desc</#if>&sortBy=id"
                                                style="text-decoration: none; color: inherit; display: inline;">
                                            #${task.id}.
                                            </a>
                                         </span>
                                            </div>
                                            <div class="company-name-document-type">
                                                <div class="task-name">
                                                    <span>${task.company.name}</span>
                                                </div>
                                                <div class="task-document">
                                                    <span>${task.documentTypeName}</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="task-details">
                                            <div class="task-details-left">
                                                <a href="?sort=<#if sort == 'desc'>asc<#else>desc</#if>&sortBy=endDate"
                                                   class="calendar-link">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                                         fill="currentColor" class="bi bi-calendar4"
                                                         viewBox="0 0 16 16">
                                                        <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M2 2a1 1 0 0 0-1 1v1h14V3a1 1 0 0 0-1-1zm13 3H1v9a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1z"/>
                                                    </svg>
                                                </a>
                                            </div>

                                            <div class="task-details-right">
                                                <span class="task-date">${dateUtils.formatDateTime(task.endDate, "dd.MM.yyyy")}</span>

                                                <div class="tag-container">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                                         fill="currentColor"
                                                         class="bi bi-tag" viewBox="0 0 16 16"
                                                         onclick="toggleTagSelect(${task.id})">
                                                        <path d="M6 4.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0m-1 0a.5.5 0 1 0-1 0 .5.5 0 0 0 1 0"/>
                                                        <path d="M2 1h4.586a1 1 0 0 1 .707.293l7 7a1 1 0 0 1 0 1.414l-4.586 4.586a1 1 0 0 1-1.414 0l-7-7A1 1 0 0 1 1 6.586V2a1 1 0 0 1 1-1m0 5.586 7 7L13.586 9l-7-7H2z"/>
                                                    </svg>

                                                    <div id="tag-modal-${task.id}" class="tag-select-modal">
                                                        <div class="tag-select-modal-content">
                                                            <span class="tag-close-button"
                                                                  onclick="closeTagModal('select', ${task.id})">&times;</span>
                                                            <h3 class="tag-modal-title">Назначьте тег для задачи</h3>
                                                            <select id="user-tags-select-${task.id}"
                                                                    class="tag-select-dropdown"
                                                                    onchange="applySelectedTag(${task.id}, this.value)">
                                                                <option value="" disabled selected>Выберите тег</option>
                                                            </select>
                                                            <button onclick="openTagModal(${task.id})"
                                                                    class="tag-add-button">+ Добавить тег
                                                            </button>
                                                        </div>
                                                    </div>

                                                </div>

                                                <div class="task-tag" data-task-id="${task.id}">
                                            <span id="tag-text-${task.id}" class="tag-text"
                                                    <#if task.tag??>
                                                data-tooltip="${task.tag}"
                                                    </#if>>
                                                <span class="tag-text-short">
                                                    <#if task.tag??>
                                                        <#if task.tag?length gt 3>
                                                            ${task.tag?substring(0, 3)}
                                                        <#else>
                                                            ${task.tag}
                                                        </#if>

                                                    </#if>
                                                </span>
                                                <span class="tag-text-full" style="display: none;">
                                                    <#if task.tag??>${task.tag}</#if>
                                                </span>
                                            </span>
                                                    <#if task.tag??>
                                                        <div id="tooltip-${task.id}" class="tooltip"
                                                             style="display: none;">
                                                            ${task.tag}
                                                        </div>
                                                    </#if>
                                                </div>

                                                <div id="tag-modal-create-${task.id}" class="tag-select-modal">
                                                    <div class="tag-select-modal-content">
                                                        <span class="tag-close-button"
                                                              onclick="closeTagModal('create', ${task.id})">&times;</span>
                                                        <h3 class="tag-modal-title">Добавьте текст для тега</h3>
                                                        <input type="text" id="tag-input-${task.id}"
                                                               class="tag-input-field" placeholder="Введите текст тега">
                                                        <input type="hidden" id="task-id-${task.id}" value="${task.id}">
                                                        <button onclick="saveTag(${task.id})" class="tag-save-button">
                                                            Сохранить
                                                        </button>
                                                    </div>
                                                </div>


                                                <a href="?sort=<#if sort == 'desc'>asc<#else>desc</#if>&sortBy=priority"
                                                   style="text-decoration: none; color: inherit; display: inline;">
                                                    <div class="task-priority-arrows" data-task-id="${task.id}">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25"
                                                             fill="currentColor" class="bi bi-sort-numeric-down"
                                                             viewBox="0 0 16 16">
                                                            <path d="M12.438 1.668V7H11.39V2.684h-.051l-1.211.859v-.969l1.262-.906h1.046z"/>
                                                            <path fill-rule="evenodd"
                                                                  d="M11.36 14.098c-1.137 0-1.708-.657-1.762-1.278h1.004c.058.223.343.45.773.45.824 0 1.164-.829 1.133-1.856h-.059c-.148.39-.57.742-1.261.742-.91 0-1.72-.613-1.72-1.758 0-1.148.848-1.835 1.973-1.835 1.09 0 2.063.636 2.063 2.687 0 1.867-.723 2.848-2.145 2.848zm.062-2.735c.504 0 .933-.336.933-.972 0-.633-.398-1.008-.94-1.008-.52 0-.927.375-.927 1 0 .64.418.98.934.98"/>
                                                            <path d="M4.5 2.5a.5.5 0 0 0-1 0v9.793l-1.146-1.147a.5.5 0 0 0-.708.708l2 1.999.007.007a.497.497 0 0 0 .7-.006l2-2a.5.5 0 0 0-.707-.708L4.5 12.293z"/>
                                                        </svg>
                                                    </div>
                                                </a>
                                            </div>

                                            <div class="task-priority-bar" data-task-id="${task.id}"
                                                 style="background-color: ${task.priorityColor};"></div>

                                            <div id="priorityModal" class="priority-modal" style="display: none;">
                                                <div class="priority-modal-content">
                                                    <span class="priority-close-button">&times;</span>
                                                    <h2 class="priority-modal-title">Выберите приоритет для задачи</h2>
                                                    <ul class="priority-list">
                                                        <#list priorities as priority>
                                                            <li class="priority-item" data-priority-id="${priority.id}">
                                                                <span class="priority-badge">${priority.name?substring(0, 1)}</span>
                                                                <span class="priority-name">${priority.name}</span>
                                                            </li>
                                                        </#list>
                                                    </ul>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </#list>
                            <#else>
                                <span class="ms-3">Список  super задач пуст</span>
                            </#if>
                        <#else>
                            <#if userTasks?has_content>
                                <#list userTasks as task>
                                    <div class="task-item task-div">
                                        <div class="task-company-document">
                                            <div class="task-id">
                                         <span>
                                             <a href="?sort=<#if sort == 'desc'>asc<#else>desc</#if>&sortBy=id"
                                                style="text-decoration: none; color: inherit; display: inline;">
                                            #${task.id}.
                                            </a>
                                         </span>
                                            </div>
                                            <div class="company-name-document-type">
                                                <div class="task-name">
                                                    <span>${task.company.name}</span>
                                                </div>
                                                <div class="task-document">
                                                    <span>${task.documentTypeName}</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="task-details">
                                            <div class="task-details-left">
                                                <a href="?sort=<#if sort == 'desc'>asc<#else>desc</#if>&sortBy=endDate"
                                                   class="calendar-link">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                                         fill="currentColor" class="bi bi-calendar4"
                                                         viewBox="0 0 16 16">
                                                        <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M2 2a1 1 0 0 0-1 1v1h14V3a1 1 0 0 0-1-1zm13 3H1v9a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1z"/>
                                                    </svg>
                                                </a>
                                            </div>

                                            <div class="task-details-right">
                                                <span class="task-date">${dateUtils.formatDateTime(task.endDate, "dd.MM.yyyy")}</span>

                                                <div class="tag-container">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                                         fill="currentColor"
                                                         class="bi bi-tag" viewBox="0 0 16 16"
                                                         onclick="toggleTagSelect(${task.id})">
                                                        <path d="M6 4.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0m-1 0a.5.5 0 1 0-1 0 .5.5 0 0 0 1 0"/>
                                                        <path d="M2 1h4.586a1 1 0 0 1 .707.293l7 7a1 1 0 0 1 0 1.414l-4.586 4.586a1 1 0 0 1-1.414 0l-7-7A1 1 0 0 1 1 6.586V2a1 1 0 0 1 1-1m0 5.586 7 7L13.586 9l-7-7H2z"/>
                                                    </svg>

                                                    <div id="tag-modal-${task.id}" class="tag-select-modal">
                                                        <div class="tag-select-modal-content">
                                                            <span class="tag-close-button"
                                                                  onclick="closeTagModal('select', ${task.id})">&times;</span>
                                                            <h3 class="tag-modal-title">Назначьте тег для задачи</h3>
                                                            <select id="user-tags-select-${task.id}"
                                                                    class="tag-select-dropdown"
                                                                    onchange="applySelectedTag(${task.id}, this.value)">
                                                                <option value="" disabled selected>Выберите тег</option>
                                                            </select>
                                                            <button onclick="openTagModal(${task.id})"
                                                                    class="tag-add-button">+ Добавить тег
                                                            </button>
                                                        </div>
                                                    </div>

                                                </div>

                                                <div class="task-tag" data-task-id="${task.id}">
                                            <span id="tag-text-${task.id}" class="tag-text"
                                                    <#if task.tag??>
                                                data-tooltip="${task.tag}"
                                                    </#if>>
                                                <span class="tag-text-short">
                                                    <#if task.tag??>
                                                        <#if task.tag?length gt 3>
                                                            ${task.tag?substring(0, 3)}
                                                        <#else>
                                                            ${task.tag}
                                                        </#if>

                                                    </#if>
                                                </span>
                                                <span class="tag-text-full" style="display: none;">
                                                    <#if task.tag??>${task.tag}</#if>
                                                </span>
                                            </span>
                                                    <#if task.tag??>
                                                        <div id="tooltip-${task.id}" class="tooltip"
                                                             style="display: none;">
                                                            ${task.tag}
                                                        </div>
                                                    </#if>
                                                </div>

                                                <div id="tag-modal-create-${task.id}" class="tag-select-modal">
                                                    <div class="tag-select-modal-content">
                                                        <span class="tag-close-button"
                                                              onclick="closeTagModal('create', ${task.id})">&times;</span>
                                                        <h3 class="tag-modal-title">Добавьте текст для тега</h3>
                                                        <input type="text" id="tag-input-${task.id}"
                                                               class="tag-input-field" placeholder="Введите текст тега">
                                                        <input type="hidden" id="task-id-${task.id}" value="${task.id}">
                                                        <button onclick="saveTag(${task.id})" class="tag-save-button">
                                                            Сохранить
                                                        </button>
                                                    </div>
                                                </div>


                                                <a href="?sort=<#if sort == 'desc'>asc<#else>desc</#if>&sortBy=priority"
                                                   style="text-decoration: none; color: inherit; display: inline;">
                                                    <div class="task-priority-arrows" data-task-id="${task.id}">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25"
                                                             fill="currentColor" class="bi bi-sort-numeric-down"
                                                             viewBox="0 0 16 16">
                                                            <path d="M12.438 1.668V7H11.39V2.684h-.051l-1.211.859v-.969l1.262-.906h1.046z"/>
                                                            <path fill-rule="evenodd"
                                                                  d="M11.36 14.098c-1.137 0-1.708-.657-1.762-1.278h1.004c.058.223.343.45.773.45.824 0 1.164-.829 1.133-1.856h-.059c-.148.39-.57.742-1.261.742-.91 0-1.72-.613-1.72-1.758 0-1.148.848-1.835 1.973-1.835 1.09 0 2.063.636 2.063 2.687 0 1.867-.723 2.848-2.145 2.848zm.062-2.735c.504 0 .933-.336.933-.972 0-.633-.398-1.008-.94-1.008-.52 0-.927.375-.927 1 0 .64.418.98.934.98"/>
                                                            <path d="M4.5 2.5a.5.5 0 0 0-1 0v9.793l-1.146-1.147a.5.5 0 0 0-.708.708l2 1.999.007.007a.497.497 0 0 0 .7-.006l2-2a.5.5 0 0 0-.707-.708L4.5 12.293z"/>
                                                        </svg>
                                                    </div>
                                                </a>
                                            </div>

                                            <div class="task-priority-bar" data-task-id="${task.id}"
                                                 style="background-color: ${task.priorityColor};"></div>

                                            <div id="priorityModal" class="priority-modal" style="display: none;">
                                                <div class="priority-modal-content">
                                                    <span class="priority-close-button">&times;</span>
                                                    <h2 class="priority-modal-title">Выберите приоритет для задачи</h2>
                                                    <ul class="priority-list">
                                                        <#list priorities as priority>
                                                            <li class="priority-item" data-priority-id="${priority.id}">
                                                                <span class="priority-badge">${priority.name?substring(0, 1)}</span>
                                                                <span class="priority-name">${priority.name}</span>
                                                            </li>
                                                        </#list>
                                                    </ul>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </#list>
                            <#else>
                                <span class="ms-3">Список задач пуст</span>
                            </#if>
                        </#if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="monthlyReportModal" tabindex="-1" aria-labelledby="monthlyReportModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="monthlyReportModalLabel">Сформировать ежемесячный отчёт</h5>
                    <button type="button" class="close btn-close report-modal-close-button" data-bs-dismiss="modal"
                            aria-label="Закрыть">
                    </button>
                </div>
                <div class="modal-body">
                    <form action="/api/reports/csv" method="post" id="monthlyReportForm">
                        <!-- CSRF -->
                        <#if _csrf??>
                            <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                                   value="${(_csrf.token)!'csrf-token'}"/>
                        </#if>
                        <div class="form-group">
                            <label>Выберите компании:</label><br>
                            <div>

                                <input type="text" id="companySearchMonthly" placeholder="Поиск компаний..."
                                       class="form-control mb-2">
                                <div class="form-check mb-2">
                                    <input type="checkbox" id="selectAllMonthly" class="form-check-input">
                                    <label class="form-check-label" for="selectAllMonthly">Выбрать все</label>
                                </div>

                                <div id="monthlyErrorContainer" class="text-danger"
                                     style="display: none; margin-bottom: 5px"></div>


                                <div id="companyCheckboxesMonthly" class="dropdown-menu p-3"
                                     style="border: 1px solid #ccc; width: 94%">
                                    <#list companies as company>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="companyIds"
                                                   id="company_${company.id}" value="${company.id}">
                                            <label class="form-check-label"
                                                   for="company_${company.id}">${company.name}</label>
                                        </div>
                                    </#list>
                                </div>
                            </div>
                        </div>


                        <div class="form-group mt-4">
                            <div class="d-flex align-items-center justify-content-center"
                                 style="margin-top: 230px; margin-bottom: 10px">
                                <div class="date-picker-container">
                                    <input type="date" id="startDateMonthly" name="startDate" class="form-control"
                                           style="font-size: 20px;">
                                </div>
                                <div class="date-picker-container">
                                    <input type="date" id="endDateMonthly" name="endDate" class="form-control"
                                           style="font-size: 20px; margin-left: 10px;">
                                </div>
                            </div>
                        </div>

                        <button type="button" class="pdf-button" id="downloadMonthlyPdfButton">Скачать в формате PDF
                        </button>


                        <div class="modal-footer" style="display: flex; justify-content: center; border: none">
                            <button type="submit" class="btn btn-light create-report-btn mt-1"
                                    id="downloadMonthlyCsvButton"><i class="bi bi-check2 fs-1"></i></button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="quarterlyReportModal" tabindex="-1" aria-labelledby="quarterlyReportModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="quarterlyReportModalLabel">Сформировать ежеквартальный отчёт</h5>
                    <button type="button" class="close btn-close report-modal-close-button" data-bs-dismiss="modal"
                            aria-label="Закрыть"></button>
                </div>
                <div class="modal-body">
                    <form action="/api/reports/csv" method="post" id="quarterlyReportForm">
                        <!-- CSRF -->
                        <#if _csrf??>
                            <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                                   value="${(_csrf.token)!'csrf-token'}"/>
                        </#if>
                        <div class="form-group">
                            <label>Выберите компании:</label><br>
                            <div>

                                <input type="text" id="companySearchQuarterly" placeholder="Поиск компаний..."
                                       class="form-control mb-2">
                                <div class="form-check mb-2">
                                    <input type="checkbox" id="selectAllQuarterly" class="form-check-input">
                                    <label class="form-check-label" for="selectAllQuarterly">Выбрать все</label>
                                </div>


                                <div id="quarterlyErrorContainer" class="text-danger"
                                     style="display: none; margin-bottom: 5px"></div>

                                <div id="companyCheckboxesQuarterly" class="dropdown-menu p-3"
                                     style="border: 1px solid #ccc; width: 94%">
                                    <#list companies as company>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="companyIds"
                                                   id="company_${company.id}" value="${company.id}">
                                            <label class="form-check-label"
                                                   for="company_${company.id}">${company.name}</label>
                                        </div>
                                    </#list>
                                </div>
                            </div>
                        </div>


                        <div class="form-group mt-4">
                            <div class="d-flex align-items-center justify-content-center"
                                 style="margin-top: 230px; margin-bottom: 10px">
                                <div class="date-picker-container">
                                    <input type="date" id="startDateQuarterly" name="startDate" class="form-control"
                                           style="font-size: 20px;">
                                </div>
                                <div class="date-picker-container">
                                    <input type="date" id="endDateQuarterly" name="endDate" class="form-control"
                                           style="font-size: 20px; margin-left: 10px;">
                                </div>
                            </div>
                        </div>

                        <button type="button" class="pdf-button" id="downloadQuarterlyPdfButton">Скачать в формате PDF
                        </button>

                        <div class="modal-footer" style="display: flex; justify-content: center; border: none">
                            <button type="submit" class="btn btn-light create-report-btn mt-1"
                                    id="downloadQuarterlyCsvButton"><i class="bi bi-check2 fs-1"></i></button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="yearlyReportModal" tabindex="-1" aria-labelledby="yearlyReportModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="yearlyReportModalLabel">Сформировать годовой отчёт</h5>
                    <button type="button" class="close btn-close report-modal-close-button" data-bs-dismiss="modal"
                            aria-label="Закрыть"></button>
                </div>
                <div class="modal-body">
                    <form action="/api/reports/csv" method="post" id="yearlyReportForm">
                        <!-- CSRF -->
                        <#if _csrf??>
                            <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                                   value="${(_csrf.token)!'csrf-token'}"/>
                        </#if>
                        <div class="form-group">
                            <label>Выберите компании:</label><br>
                            <div>

                                <input type="text" id="companySearchYearly" placeholder="Поиск компаний..."
                                       class="form-control mb-2">
                                <div class="form-check mb-2">
                                    <input type="checkbox" id="selectAllYearly" class="form-check-input">
                                    <label class="form-check-label" for="selectAllYearly">Выбрать все</label>
                                </div>

                                <div id="yearlyErrorContainer" class="text-danger"
                                     style="display: none; margin-bottom: 5px"></div>


                                <div id="companyCheckboxesYearly" class="dropdown-menu p-3"
                                     style="border: 1px solid #ccc; width: 94%">
                                    <#list companies as company>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="companyIds"
                                                   id="company_${company.id}" value="${company.id}">
                                            <label class="form-check-label"
                                                   for="company_${company.id}">${company.name}</label>
                                        </div>
                                    </#list>
                                </div>
                            </div>
                        </div>


                        <div class="form-group mt-4">
                            <div class="d-flex align-items-center justify-content-center"
                                 style="margin-top: 230px; margin-bottom: 10px">
                                <div class="date-picker-container">
                                    <input type="date" id="startDateYearly" name="startDate" class="form-control"
                                           style="font-size: 20px;">
                                </div>
                                <div class="date-picker-container">
                                    <input type="date" id="endDateYearly" name="endDate" class="form-control"
                                           style="font-size: 20px; margin-left: 10px;">
                                </div>
                            </div>
                        </div>
                        <button type="button" class="pdf-button" id="downloadYearlyPdfButton">Скачать в формате PDF
                        </button>


                        <div class="modal-footer" style="display: flex; justify-content: center; border: none">
                            <button type="submit" class="btn btn-light create-report-btn mt-1"
                                    id="downloadYearlyCsvButton"><i class="bi bi-check2 fs-1"></i></button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div id="legendMapModal" class="legend-map-modal" style="display: none;">
        <div class="modal-content-map">
            <span class="close-btn" onclick="closeModal()">&times;</span>
            <h2>Руководство по управлению задачами
                <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor"
                     class="bi bi-person-raised-hand" viewBox="0 0 16 16" style="margin-left: 8px;">
                    <path d="M6 6.207v9.043a.75.75 0 0 0 1.5 0V10.5a.5.5 0 0 1 1 0v4.75a.75.75 0 0 0 1.5 0v-8.5a.25.25 0 1 1 .5 0v2.5a.75.75 0 0 0 1.5 0V6.5a3 3 0 0 0-3-3H6.236a1 1 0 0 1-.447-.106l-.33-.165A.83.83 0 0 1 5 2.488V.75a.75.75 0 0 0-1.5 0v2.083c0 .715.404 1.37 1.044 1.689L5.5 5c.32.32.5.754.5 1.207"/>
                    <path d="M8 3a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3"/>
                </svg>
            </h2>
            <p><strong>1. Сортировка по номеру задачи:</strong> Если нажать на номер задачи, вы можете отсортировать их
                по убыванию или возрастанию.</p>
            <p><strong>2. Сортировка по дате:</strong> Аналогично, если нажать на дату, можно отсортировать задачи по
                возрастанию или убыванию дат.</p>
            <p><strong>3. Сортировка по приоритету:</strong> Если нажать на иконку сортировки справа от тега, задачи
                будут отсортированы по приоритетам.</p>
            <p><strong>4. Создание задачи:</strong> Нажмите на иконку с плюсом, чтобы перейти к созданию новой задачи.
            </p>
            <p><strong>5. Добавление тега к задаче:</strong> Нажмите на иконку бирки, чтобы открыть окно для выбора
                тега. Также в окне сбоку будет находиться кнопка с плюсом для создания нового тега.</p>
            <p><strong>6. Добавление приоритета к задаче:</strong> Нажмите на серый блок, чтобы открыть окно для выбора
                приоритета. Выберите нужный приоритет из предложенного списка.</p>
        </div>
    </div>


    <style>
        .legend-map-modal {
            display: none;
            position: fixed;
            top: 1%;
            left: 50%;
            transform: translateX(-50%);
            width: 70%;
            height: 100%;
            z-index: 1000;
            justify-content: center;
            align-items: center;
            display: flex;
            opacity: 0;
            transition: opacity 0.3s ease, transform 0.3s ease;
            transform: translateX(-50%) scale(0.9);
        }

        .legend-map-modal.show {
            display: flex;
            opacity: 1;
            transform: translateX(-50%) scale(1);
        }

        .modal-content-map {
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            width: 60%;
            max-width: 800px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
            overflow-y: auto;
            position: relative;
        }

        #legendMapModal .close-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 30px;
            color: #999;
            cursor: pointer;
            background: none;
            border: none;
            font-weight: bold;
        }

        .main-container {
            max-width: 1350px;
        }

        .main {
            display: flex;
            flex-wrap: wrap;
            margin-top: 45px;
        }

        .main-content {
            height: 270px;
            width: 270px;

            box-shadow: 2px 0 5px #BFBFBF, -2px 0 5px #BFBFBF, 0 5px 5px #BFBFBF;
            border: 1px solid #BFBFBF;
        }

        .left-content {
            display: flex;
            flex-direction: row;
            flex-wrap: wrap;
        }

        .report-archive {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .report-button {
            height: 39px;
            width: 270px;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #FFFFFF;
            text-align: center;
            margin: 0;
            color: #000000;
            position: relative;
            box-shadow: 0 5px 5px #a3a3a3;
        }

        .report-button p {
            margin: 0;
            line-height: 1;
        }

        .reports {
            height: 270px;
            width: 270px;
        }

        .report-header {
            margin-top: 8px;
            font-size: 15px;
            background-color: #EBEBEB;
        }

        .report-icon {
            position: absolute;
            top: 5px;
            right: 5px;
            width: 20px;
            height: 20px;
            fill: black;
            stroke: black;
            stroke-width: 1.5px;
            cursor: pointer;
        }

        .report-header-text {
        }

        .report-content {
            background-color: #d9d9d9;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 5px;
            height: 270px;
        }

        .report-monthly {
            font-size: 24px;
        }

        .report-quarterly {
            font-size: 24px;
        }

        .report-yearly {
            font-size: 24px;
        }

        .archives {
            height: 270px;
            width: 270px;
            background-color: #d9d9d9;
        }

        .archive-header {
            background-color: #FFFFFF;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #000000;
            text-align: center;
            height: 53px;
            font-size: 24px;
        }

        .archive-header p {
            margin: 0;
            line-height: 1;
        }

        .archive-content {
            background-color: #d9d9d9;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .selectDisable {
            -webkit-user-select: none;
            -khtml-user-select: none;
            -moz-user-select: none;
            -o-user-select: none;
            user-select: none;
        }

        .company-calendar {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .companies {
            background-color: #d9d9d9;
            display: flex;
            flex-direction: column;
            justify-content: space-evenly;
            align-items: center;
            gap: 20px;
            padding: 20px 0;
        }

        .company-button {
            background-color: #FFFFFF;
            height: 60px;
            width: 270px;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            color: #000000;
            font-size: 24px;

            box-shadow: 0 5px 5px #a3a3a3;
        }

        .company-button p {
            margin: 0;
            line-height: 1;
        }

        .calendars {
            overflow: hidden;
        }

        .calendar-header {
            background-color: #FFFFFF;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #000000;
            text-align: center;
            height: 53px;
            font-size: 24px;
        }

        .calendar-header p {
            margin: 0;
            line-height: 1;
        }

        .calendar-content {
            background-color: #FFFFFF;
            height: 100%;
        }


        .calendar-table {
            width: 100%;
            height: 90%;
            border-collapse: collapse;
            font-size: 10px;
        }

        .td-calendar {
            text-align: center;
            padding: 2px;
            height: calc(197px / 8);
            box-sizing: border-box;
        }

        .calendar-month-date {
            font-size: 12px;
            font-weight: bold;
        }

        .days {
            font-size: 10px;
            font-weight: bold;
        }

        .calendar-left, .calendar-right {
            width: 20px;
        }

        .calendar-left button, .calendar-right button {
            width: 16px;
            height: 16px;
            font-size: 8px;
            padding: 0;
        }

        .today {
            background-color: #add8e6;
            border-radius: 4px;
        }

        .not-current {
            color: #ccc;
        }

        .tasks {
            max-width: 650px;
            height: 560px;


            box-shadow: 2px 0 5px #BFBFBF, -2px 0 5px #BFBFBF, 0 5px 5px #BFBFBF;
            border: 1px solid #BFBFBF;
        }

        .tasks-header {
            background-color: #FFFFFF;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 24px;
            text-align: center;
            height: 53px;
            position: relative;
        }

        .tasks-header h3 {
            margin: 0 auto;
            position: absolute;
            transform: translateX(-50%);
        }

        .tasks-header .task-actions {
            display: flex;
            align-items: center;
            margin-left: auto;
        }

        .tasks-header .help-task {
            margin-right: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .tasks-header .add-task {
            display: flex;
            align-items: center;
            justify-content: center;
        }


        .tasks-content {
            height: 500px;
            overflow: hidden;
        }

        .tasks-scroll {
            background-color: #d9d9d9;
            max-height: 500px;
            overflow-y: auto;

            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .task-details {
            background-color: #FFFFFF;

            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .select-for-task{
            display: flex;
        }

        .task-details-right {
            display: flex;
            flex-direction: row;
            margin-right: 40px;
            align-items: center;
            justify-content: center;
        }

        .task-id {
            width: 30px;
        }

        .task-tag {
            width: 50px;
        }

        .task-list {
            height: 517px;
        }

        .task-priority-arrows {
            width: 25px;
            height: 20px;
            margin: 9px;
        }

        .task-div {
            height: 60px;
            margin: 0;
            border: 0;
            box-shadow: 0 5px 5px #a3a3a3;

        }

        .task-company-document {
            width: 350px;
            display: flex;
            flex-direction: row;
            align-items: center;
        }

        .company-name-document-type {
            display: flex;
            flex-direction: column;
            margin-left: 10px;
        }

        .task-name {
            display: inline-block;
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            vertical-align: middle;
        }

        .task-document {
            display: inline-block;
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            vertical-align: middle;
        }

        .task-id {
            width: 50px;
        }

        @media (min-width: 1305px) {
            body {
                overflow-y: hidden;
            }
        }


    </style>
    <script src="/js/legendMap.js"></script>
    <script src="/js/tags.js"></script>
    <script src="/js/priority.js"></script>
    <script src="/js/reports.js"></script>
</@layout.layout>