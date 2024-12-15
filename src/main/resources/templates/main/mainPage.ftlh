<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>

    <div class="container p-3">
        <div class="main row">
            <div class="col-6">
                <div class="left-content row">
                    <div class="col-6 report-archive column">
                        <div class="reports col-6 main-content">

                            <div class="report-content">
                                <a href="/report/create">
                                    <div class="report-header report-button">
                                        <p>СФОРМИРОВАТЬ ОТЧЕТ</p>
                                    </div>
                                </a>
                                <a href="/tasks/create/everyMonth">
                                    <div class="report-monthly report-button">
                                        <p>ЕЖЕМЕСЯЧНЫЙ</p>
                                    </div>
                                </a>
                                <a href="/tasks/create/everyQuarter">
                                    <div class="report-quarterly report-button">
                                        <p>КВАРТАЛЬНЫЙ</p>
                                    </div>
                                </a>
                                <a href="/tasks/create/everyYear">
                                    <div class="report-yearly report-button">
                                        <p>ГОДОВОЙ</p>
                                    </div>
                                </a>
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
            <div class="col-6">
                <div class="tasks">
                    <div class="tasks-header">
                        <p>ЗАДАЧИ</p>
                    </div>

                    <div class="tasks-content">
                        <div class="tasks-scroll">
                            <#if userTasks?has_content>
                                <#list userTasks as task>
                                    <div class="task-details">
                                        <div class="task-id">
                                            <p>#${task.id}</p>
                                        </div>
                                        <div class="task-company">
                                            <p>${task.company.name}</p>
                                        </div>
                                        <div class="task-document-type">
                                            <p>${task.documentTypeName}</p>
                                        </div>
                                        <div class="task-date">
                                            ${dateUtils.formatDateTime(task.endDate, "dd.MM.yyyy")}
                                        </div>
                                        <div class="task-tag">
                                            <div>
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                                     fill="currentColor"
                                                     class="bi bi-tag" viewBox="0 0 16 16"
                                                     onclick="toggleTagSelect(${task.id})">
                                                    <path d="M6 4.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0m-1 0a.5.5 0 1 0-1 0 .5.5 0 0 0 1 0"/>
                                                    <path d="M2 1h4.586a1 1 0 0 1 .707.293l7 7a1 1 0 0 1 0 1.414l-4.586 4.586a1 1 0 0 1-1.414 0l-7-7A1 1 0 0 1 1 6.586V2a1 1 0 0 1 1-1m0 5.586 7 7L13.586 9l-7-7H2z"/>
                                                </svg>
                                            </div>

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

                                        <div class="task-priority-arrows">
                                            <#if task.priorityId?has_content>
<#--                                                <#list 1..task.priorityId as i>-->
<#--                                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"-->
<#--                                                         fill="currentColor"-->
<#--                                                         class="bi bi-caret-up" viewBox="0 0 16 16">-->
<#--                                                        <path d="M3.204 11h9.592L8 5.519zm-.753-.659 4.796-5.48a1 1 0 0 1 1.506 0l4.796 5.48c.566.647.106 1.659-.753 1.659H3.204a1 1 0 0 1-.753-1.659"/>-->
<#--                                                    </svg>-->
<#--                                                </#list>-->

                                                <img src="/images/${task.priorityId}-arrow.png" alt="priority">
                                            <#else>
<#--                                                <span class="no-priority-message"></span>-->
                                            </#if>
                                        </div>

                                        <div class="task-priority-bar" data-task-id="${task.id}"
                                             style="background-color: ${task.priorityColor};">

                                        </div>



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
                                </#list>
                            <#else>
                                <span class="ms-3">Список задач пуст</span>
                            </#if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .main {
            height: 800px;
        }

        .main-content {
            height: 250px;
            width: 250px;

            box-shadow: 2px 0 5px #BFBFBF, -2px 0 5px #BFBFBF, 0 5px 5px #BFBFBF;
            border: 1px solid #BFBFBF;
        }

        .left-content {
        }

        .report-archive {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .report-button {
            height: 39px;
            width: 250px;
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
            height: 250px;
            width: 250px;


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
            gap: 16px;
            height: 250px;
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
            height: 250px;
            width: 250px;
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
            width: 250px;
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
            width: 650px;

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
            gap: 10px;
        }

        .task-details {
            background-color: #FFFFFF;
            height: 70px;
        }

        .task-id {
            width: 30px;
        }

        .task-company {
            width: 150px;
        }

        .task-document-type {
            width: 120px;

        }

        .task-tag {

        }

        .task-status {

        }

        .task-priority-arrows {
            height: 45px;
            width: 15px;
        }

    </style>

    <script src="/js/tags.js"></script>
    <script src="/js/priority.js"></script>
</@layout.layout>
