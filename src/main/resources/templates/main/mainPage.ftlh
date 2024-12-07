<#import '../layout.ftlh' as main>

<@main.layout ; spring>
    <div class="main-page">
        <div class="row row-cols-1 row-cols-lg-2 g-5">
            <div class="col">
                <div class="row row-cols-1 row-cols-md-2 g-1">
                    <div class="left col">
                        <div class="sidebar">
                            <a href="/report/create" class="button lock btn type-btn">СФОРМИРОВАТЬ ОТЧЕТ</a>
                            <button type="button" class="button btn type-btn" data-bs-toggle="modal" data-bs-target="#monthlyReportModal">
                                ЕЖЕМЕСЯЧНЫЙ
                            </button>
                            <a href="/tasks/create/everyQuarter" class="button btn type-btn">ЕЖЕКВАРТАЛЬНЫЙ</a>
                            <button type="button" class="button btn type-btn" data-bs-toggle="modal" data-bs-target="#monthlyReportModal">
                                ГОДОВОЙ
                            </button>
                        </div>
                    </div>
                    <div class="left col">
                        <div class="center-column">
                            <a href="/company/all?sort=actual&openModal=true" class="button company btn type-btn mt-5">СОЗДАТЬ НОВЫЙ ИП/ОСОО</a>
                            <a href="/company/all?sort=actual" class="button company btn type-btn">СПИСОК КОМПАНИЙ</a>
                        </div>
                    </div>
                    <div class="left col">
                        <div class="archive">
                            <#assign hasAccess = false />
                            <#list userDto.role.authorities as auth>
                                <#if auth.authority == "VIEW_ARCHIVE">
                                    <#assign hasAccess = true />
                                    <#break>
                                </#if>
                            </#list>
                            <a href="${hasAccess?then('/archive/all', '/archive')}" class="btn type-btn">
                                <h3>АРХИВ</h3>
                                <ul>
                                    <li>&bull;</li>
                                    <li>&bull;</li>
                                </ul>
                            </a>
                        </div>
                    </div>
                    <div class="left col">
                            <div class="calendar-wrapper">
                                <h3 class="text-center calendar-h">КАЛЕНДАРЬ</h3>
                                <div id="divCal"></div>
                                <input type="hidden" name="_csrf" value="${csrfToken.token}">
                            </div>
                    </div>
                </div>
            </div>
            <div class="col tasks">
                <div class="tasks-header">
                    <h3><a href="/tasks/list" class="btn type-submit ms-5">ЗАДАЧИ</a></h3>
                    <a href="/tasks/create" class="btn type-btn add-task">
                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" font-weight="bold"
                             fill="currentColor" class="bi bi-plus-circle" viewBox="0 0 16 16">
                            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                        </svg>
                    </a>
                </div>

                <div class="task-list">
                    <#if userTasks?has_content>
                        <#list userTasks as task>
                            <div class="task-item mt-4">

                             <span>
                                 <a href="?sort=<#if sort == 'desc'>asc<#else>desc</#if>&sortBy=id"
                                    style="text-decoration: none; color: inherit; display: inline;">
                                #${task.id}.
                                </a>${task.company.name}${task.documentTypeName}
                             </span>

                                <div class="task-details">

                                    <a href="?sort=<#if sort == 'desc'>asc<#else>desc</#if>&sortBy=endDate"
                                       class="calendar-link">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                             fill="currentColor" class="bi bi-calendar4" viewBox="0 0 16 16">
                                            <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M2 2a1 1 0 0 0-1 1v1h14V3a1 1 0 0 0-1-1zm13 3H1v9a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1z"/>
                                        </svg>
                                    </a>

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
                                            <#list 1..task.priorityId as i>
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                                     fill="currentColor"
                                                     class="bi bi-caret-up" viewBox="0 0 16 16">
                                                    <path d="M3.204 11h9.592L8 5.519zm-.753-.659 4.796-5.48a1 1 0 0 1 1.506 0l4.796 5.48c.566.647.106 1.659-.753 1.659H3.204a1 1 0 0 1-.753-1.659"/>
                                                </svg>
                                            </#list>
                                        <#else>
                                            <span class="no-priority-message"></span>
                                        </#if>
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


    <div class="modal fade" id="monthlyReportModal" tabindex="-1" aria-labelledby="monthlyReportModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="monthlyReportModalLabel">Сформировать ежемесячный отчёт</h5>
                    <button type="button" class="close btn-close report-modal-close-button" data-bs-dismiss="modal" aria-label="Закрыть">
                    </button>
                </div>
                <div class="modal-body">
                    <form action="/reports/monthly" method="post">
                        <!-- CSRF -->
                        <#if _csrf??>
                            <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                                   value="${(_csrf.token)!'csrf-token'}"/>
                        </#if>
                        <div class="form-group">
                            <label>Выберите компании:</label><br>
                            <#list companies as company>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="companyIds" value="${company.id}">
                                    <label class="form-check-label">${company.name}</label>
                                </div>
                            </#list>
                        </div>

                        <div class="form-group">
                            <label for="yearSelect">Год:</label>
                            <select class="form-control" id="yearSelect" name="year">
                                <#assign currentYear = .now?string("yyyy")?number>
                                <#list (currentYear - 2)..(currentYear + 2) as y>
                                    <option value="${y}" <#if y == currentYear>selected</#if>>${y}</option>
                                </#list>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="monthSelect">Месяц:</label>
                            <select class="form-control" id="monthSelect" name="month">
                                <option value="1">Январь</option>
                                <option value="2">Февраль</option>
                                <option value="3">Март</option>
                                <option value="4">Апрель</option>
                                <option value="5">Май</option>
                                <option value="6">Июнь</option>
                                <option value="7">Июль</option>
                                <option value="8">Август</option>
                                <option value="9">Сентябрь</option>
                                <option value="10">Октябрь</option>
                                <option value="11">Ноябрь</option>
                                <option value="12">Декабрь</option>
                            </select>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                            <button type="submit" class="btn btn-primary">Сформировать</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</@main.layout>
<script src="/js/tags.js"></script>
<script src="/js/priority.js"></script>