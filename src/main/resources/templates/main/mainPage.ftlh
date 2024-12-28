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
                                    </div>
                                </a>
                                <button type="button" class="button btn type-btn reports-btn" data-bs-toggle="modal" data-bs-target="#monthlyReportModal">
                                    ЕЖЕМЕСЯЧНЫЙ
                                </button>
                                <button type="button" class="button btn type-btn reports-btn " data-bs-toggle="modal" data-bs-target="#quarterlyReportModal">
                                    ЕЖЕКВАРТАЛЬНЫЙ
                                </button>
                                <button type="button" class="button btn type-btn reports-btn" data-bs-toggle="modal" data-bs-target="#yearlyReportModal">
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
                            <a href="/company/all?sort=actual&openModal=true">
                                <div class="company-button">
                                    <div class="button-text company-text">
                                        <p>СОЗДАТЬ НОВЫЙ<br>ИП/ОСОО</p>
                                    </div>
                                </div>
                            </a>
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
                    <h3><a href="/tasks" class="btn type-submit ms-5">ЗАДАЧИ</a></h3>
                    <a href="/tasks?openModal=true" class="btn type-btn add-task">
                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" font-weight="bold"
                             fill="currentColor" class="bi bi-plus-circle" viewBox="0 0 16 16">
                            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                        </svg>
                    </a>
                        <#if canOpenDocumentTools>
                            <button type="button" class="btn btn-light" title="Редактирование документов" data-bs-toggle="modal" data-bs-target="#documentTypeTools"><i class="bi bi-file-diff"></i></button>
                        </#if>
                        <#if canOpenTaskTools>
                            <button type="button" class="btn btn-light" title="Редактирование статусов" data-bs-toggle="modal" data-bs-target="#taskStatusTools"><i class="bi bi-c-circle"></i></button>
                        </#if>
                </div>

                <div class="task-list">
                    <div class="tasks-scroll">
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
                                                 fill="currentColor" class="bi bi-calendar4" viewBox="0 0 16 16">
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

                                            <div id="tag-modal-${task.id}" class="tag-select-modal" style="display: none;">
                                                <div class="tag-select-modal-content">
                                                    <span class="tag-close-button"
                                                          onclick="closeTagModal('select', ${task.id})">&times;</span>
                                                    <h3>Выберите тег</h3>
                                                    <select id="user-tags-select-${task.id}"
                                                            onchange="applySelectedTag(${task.id}, this.value)">
                                                        <option value="" disabled selected>Выберите тег</option>
                                                    </select>
                                                    <button onclick="openTagModal(${task.id})" class="tag-add-button">+
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
                                                <div id="tooltip-${task.id}" class="tooltip" style="display: none;">
                                                    ${task.tag}
                                                </div>
                                            </#if>
                                        </div>

                                        <div id="tag-modal-create-${task.id}" class="tag-select-modal"
                                             style="display: none;">
                                            <div class="tag-select-modal-content">
                                            <span class="tag-close-button"
                                                  onclick="closeTagModal('create', ${task.id})">&times;</span>
                                                <h3 class="tag-modal-title">Добавьте текст для тега</h3>
                                                <input type="text" id="tag-input-${task.id}"
                                                       placeholder="Введите текст тега">
                                                <input type="hidden" id="task-id-${task.id}" value="${task.id}">
                                                <button onclick="saveTag(${task.id})" class="tag-save-button">Сохранить
                                                </button>
                                            </div>
                                        </div>

                                        <div class="task-priority-arrows" data-task-id="${task.id}">
                                            <#if task.priorityId?has_content>
                                                <img src="/images/${task.priorityId}-arrow.png" alt="priority">
                                            <#else>
                                                <span class="no-priority-message"></span>
                                            </#if>
                                        </div>
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
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="monthlyReportModal" tabindex="-1" aria-labelledby="monthlyReportModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="monthlyReportModalLabel">Сформировать ежемесячный отчёт</h5>
                    <button type="button" class="close btn-close report-modal-close-button" data-bs-dismiss="modal" aria-label="Закрыть">
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

                                <input type="text" id="companySearchMonthly" placeholder="Поиск компаний..." class="form-control mb-2">
                                <div class="form-check mb-2">
                                    <input type="checkbox" id="selectAllMonthly" class="form-check-input">
                                    <label class="form-check-label" for="selectAllMonthly">Выбрать все</label>
                                </div>

                                <div id="monthlyErrorContainer" class="text-danger" style="display: none; margin-bottom: 5px"></div>


                                <div id="companyCheckboxesMonthly" class="dropdown-menu p-3" style="border: 1px solid #ccc; width: 94%">
                                    <#list companies as company>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="companyIds" id="company_${company.id}" value="${company.id}">
                                            <label class="form-check-label" for="company_${company.id}">${company.name}</label>
                                        </div>
                                    </#list>
                                </div>
                            </div>
                        </div>



                        <div class="form-group mt-4">
                            <div class="d-flex align-items-center justify-content-center" style="margin-top: 230px; margin-bottom: 10px">
                                <div class="date-picker-container">
                                    <input type="date" id="startDateMonthly" name="startDate" class="form-control" style="font-size: 20px;">
                                </div>
                                <div class="date-picker-container">
                                    <input type="date" id="endDateMonthly" name="endDate" class="form-control" style="font-size: 20px; margin-left: 10px;">
                                </div>
                            </div>
                        </div>

                        <button type="button" class="pdf-button" id="downloadMonthlyPdfButton">Скачать в формате PDF</button>


                        <div class="modal-footer" style="display: flex; justify-content: center; border: none">
                            <button type="submit" class="btn btn-light create-report-btn mt-1" id="downloadMonthlyCsvButton"><i class="bi bi-check2 fs-1"></i></button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="quarterlyReportModal" tabindex="-1" aria-labelledby="quarterlyReportModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="quarterlyReportModalLabel">Сформировать ежеквартальный отчёт</h5>
                    <button type="button" class="close btn-close report-modal-close-button" data-bs-dismiss="modal" aria-label="Закрыть"></button>
                </div>
                <div class="modal-body">
                    <form action="/api/reports/csv" method="post" id="quarterlyReportForm">
                        <!-- CSRF -->
                        <#if _csrf??>
                            <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}" value="${(_csrf.token)!'csrf-token'}"/>
                        </#if>
                        <div class="form-group">
                            <label>Выберите компании:</label><br>
                            <div>

                                <input type="text" id="companySearchQuarterly" placeholder="Поиск компаний..." class="form-control mb-2">
                                <div class="form-check mb-2">
                                    <input type="checkbox" id="selectAllQuarterly" class="form-check-input">
                                    <label class="form-check-label" for="selectAllQuarterly">Выбрать все</label>
                                </div>


                                <div id="quarterlyErrorContainer" class="text-danger" style="display: none; margin-bottom: 5px"></div>

                                <div id="companyCheckboxesQuarterly" class="dropdown-menu p-3" style="border: 1px solid #ccc; width: 94%">
                                    <#list companies as company>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="companyIds" id="company_${company.id}" value="${company.id}">
                                            <label class="form-check-label" for="company_${company.id}">${company.name}</label>
                                        </div>
                                    </#list>
                                </div>
                            </div>
                        </div>


                        <div class="form-group mt-4">
                            <div class="d-flex align-items-center justify-content-center" style="margin-top: 230px; margin-bottom: 10px">
                                <div class="date-picker-container">
                                    <input type="date" id="startDateQuarterly" name="startDate" class="form-control" style="font-size: 20px;">
                                </div>
                                <div class="date-picker-container">
                                    <input type="date" id="endDateQuarterly" name="endDate" class="form-control" style="font-size: 20px; margin-left: 10px;">
                                </div>
                            </div>
                        </div>

                        <button type="button" class="pdf-button" id="downloadQuarterlyPdfButton">Скачать в формате PDF</button>

                        <div class="modal-footer" style="display: flex; justify-content: center; border: none">
                            <button type="submit" class="btn btn-light create-report-btn mt-1" id="downloadQuarterlyCsvButton"><i class="bi bi-check2 fs-1"></i></button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="yearlyReportModal" tabindex="-1" aria-labelledby="yearlyReportModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="yearlyReportModalLabel">Сформировать годовой отчёт</h5>
                    <button type="button" class="close btn-close report-modal-close-button" data-bs-dismiss="modal" aria-label="Закрыть"></button>
                </div>
                <div class="modal-body">
                    <form action="/api/reports/csv" method="post" id="yearlyReportForm">
                        <!-- CSRF -->
                        <#if _csrf??>
                            <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}" value="${(_csrf.token)!'csrf-token'}"/>
                        </#if>
                        <div class="form-group">
                            <label>Выберите компании:</label><br>
                            <div>

                                <input type="text" id="companySearchYearly" placeholder="Поиск компаний..." class="form-control mb-2">
                                <div class="form-check mb-2">
                                    <input type="checkbox" id="selectAllYearly" class="form-check-input">
                                    <label class="form-check-label" for="selectAllYearly">Выбрать все</label>
                                </div>

                                <div id="yearlyErrorContainer" class="text-danger" style="display: none; margin-bottom: 5px"></div>


                                <div id="companyCheckboxesYearly" class="dropdown-menu p-3" style="border: 1px solid #ccc; width: 94%">
                                    <#list companies as company>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="companyIds" id="company_${company.id}" value="${company.id}">
                                            <label class="form-check-label" for="company_${company.id}">${company.name}</label>
                                        </div>
                                    </#list>
                                </div>
                            </div>
                        </div>



                        <div class="form-group mt-4">
                            <div class="d-flex align-items-center justify-content-center" style="margin-top: 230px; margin-bottom: 10px">
                                <div class="date-picker-container">
                                    <input type="date" id="startDateYearly" name="startDate" class="form-control" style="font-size: 20px;">
                                </div>
                                <div class="date-picker-container">
                                    <input type="date" id="endDateYearly" name="endDate" class="form-control" style="font-size: 20px; margin-left: 10px;">
                                </div>
                            </div>
                        </div>
                        <button type="button" class="pdf-button" id="downloadYearlyPdfButton">Скачать в формате PDF</button>


                        <div class="modal-footer" style="display: flex; justify-content: center; border: none">
                            <button type="submit" class="btn btn-light create-report-btn mt-1" id="downloadYearlyCsvButton"><i class="bi bi-check2 fs-1"></i></button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="documentTypeTools" tabindex="-1" aria-labelledby="documentTypeToolsLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="documentTypeToolsLabel">Настройка типов документов</h5>
                    <button type="button" class="close btn-close" data-bs-dismiss="modal" aria-label="Закрыть"></button>
                </div>
                <div class="modal-body">
                    <h5>Виды документов</h5>
                    <div class="list-document-types-scroll" style="overflow: scroll; max-height: 300px">
                        <#list defaultDocumentTypes as documentType>
                            <p>${documentType.name}</p>
                        </#list>
                        <#list changeableDocumentTypes as documentTypeChangeable>
                                    <p id="documentType${documentTypeChangeable.id}" class="inline-block">
                                        ${documentTypeChangeable.name}
                                        <button type="button"><i class="bi bi-trash"></i></button>
                                        <button type="button" id="editBtndocumentType${documentTypeChangeable.id}" onclick="editDocumentType('documentType${documentTypeChangeable.id}')"
                                                title="Редактировать" class="btn btn-link p-0"><i class="bi bi-pencil"></i>
                                        </button>
                                    </p>
                                <div class="document-type-changeable-name-edit">
                                      <input type="text" id="editInputdocumentType${documentTypeChangeable.id}" class="form-control d-none"
                                       value="${documentTypeChangeable.name!}">
                                      <button id="cancelBtndocumentType${documentTypeChangeable.id}" class="btn btn-light d-none"
                                        onclick="cancelEditDocumentType('documentType${documentTypeChangeable.id}')">&#10005;
                                      </button>
                                      <button id="saveBtndocumentType${documentTypeChangeable.id}" class="btn btn-light d-none"
                                         onclick="saveChangesDocumentType('documentType${documentTypeChangeable.id}', ${documentTypeChangeable.id})">&#10003;
                                      </button>
                                </div>
                        </#list>
                    </div>
                    <span id="documentTypeToolsError" class="text-danger"></span>
                    <form id="createDocumentTypeForm">
                        <#if _csrf??>
                            <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                                   value="${(_csrf.token)!'csrf-token'}"/>
                        </#if>
                        <div class="form-group">
                            <label for="createDocumentType">Создать новый вид документа</label>
                            <input type="text" id="createDocumentType" name="name" class="form-control" required>
                            <span id="documentTypeNameError" class="text-danger"></span>
                        </div>
                    </form>
                </div>
                <div class="modal-footer d-flex justify-content-center">
                    <button type="button" class="btn btn-success" onclick="createNewDocumentType()"><i class="bi bi-check2"></i></button>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="taskStatusTools" tabindex="-1" aria-labelledby="taskStatusToolsLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="taskStatusToolsLabel">Настройка статусов</h5>
                    <button type="button" class="close btn-close" data-bs-dismiss="modal" aria-label="Закрыть"></button>
                </div>
                <div class="modal-body">
                    <h5>Статусы Задач</h5>
                    <div class="list-task-status-scroll" style="overflow: scroll; max-height: 300px">
                        <#list defaultTaskStatuses as taskStatus>
                            <p>${taskStatus.name}</p>
                        </#list>
                        <#list changeableTaskStatuses as taskStatusChangeable>
                            <p id="taskStatus${taskStatusChangeable.id}" class="inline-block">
                                ${taskStatusChangeable.name}
                                <button type="button"><i class="bi bi-trash"></i></button>
                                <button type="button" id="editBtntaskStatus${taskStatusChangeable.id}" onclick="editTaskStatus('taskStatus${taskStatusChangeable.id}')"
                                        title="Редактировать" class="btn btn-link p-0"><i class="bi bi-pencil"></i></button>
                            </p>
                            <div class="task-status-changeable-name-edit">
                                <div>
                                    <input type="text" id="editInputtaskStatus${taskStatusChangeable.id}" class="form-control d-none"
                                           value="${taskStatusChangeable.name!}">
                                    <button id="cancelBtntaskStatus${taskStatusChangeable.id}" class="btn btn-light d-none"
                                            onclick="cancelEditTaskStatus('taskStatus${taskStatusChangeable.id}')">&#10005;
                                    </button>
                                    <button id="saveBtntaskStatus${taskStatusChangeable.id}" class="btn btn-light d-none"
                                            onclick="saveChangesTaskStatus('taskStatus${taskStatusChangeable.id}', ${taskStatusChangeable.id})">&#10003;
                                    </button>
                                </div>
                            </div>
                        </#list>
                    </div>
                    <span id="taskStatusToolsError" class="text-danger"></span>
                    <form id="taskStatusForm">
                        <#if _csrf??>
                            <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                                   value="${(_csrf.token)!'csrf-token'}"/>
                        </#if>
                        <div class="form-group">
                            <label for="createTaskStatus">Создать новый статуса для задач</label>
                            <input type="text" id="createTaskStatus" name="name" class="form-control" required>
                            <span id="taskStatusNameError" class="text-danger"></span>
                        </div>
                    </form>
                </div>
                <div class="modal-footer d-flex justify-content-center">
                    <button type="button" class="btn btn-success" onclick="createNewTaskStatus()"><i class="bi bi-check2"></i></button>
                </div>
            </div>
        </div>
    </div>

    <style>
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
            height: 197px;
        }


        .calendar-table {
            width: 100%;
            height: 197px;
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
            justify-content: center;
            align-items: center;
            font-size: 24px;
            text-align: center;
            padding: 0;
            height: 53px;
        }
        .tasks-header p {
            margin: 0;
            line-height: 1;
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
            height: 55px;
            margin: 0;
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

    <script src="/js/tags.js"></script>
    <script src="/js/priority.js"></script>
    <script src="/js/reports.js"></script>
</@layout.layout>
