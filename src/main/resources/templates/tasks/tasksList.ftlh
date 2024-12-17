<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <#if errorMsg??>
        <div class="alert alert-danger">
            <p>На вас нет зарегестрированных компаний!</p>
        </div>
    </#if>
    <div class="container p-3">
        <div class="main-content">
            <div class="table-container company-table" id="company-table" style="display: block">
                <div class="table-wrapper">
                    <table class="table-main">
                        <thead>
                        <tr class="company-column-tr">
                            <th class="company-column-th">
                                <div class="company-header">
                                    <span>Компании</span>
                                </div>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <#list list as company>
                            <tr class="table-striped-row">
                                <td class="company-columns">${company.name}</td>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>

                <div class="pagination-container">
                    <#if currentPage == 0 && currentPage == totalPages - 1>

                    </#if>
                    <#if currentPage != 0>
                        <a href="javascript:void(0)" id="prevPage" class="pagination-link" data-page="${currentPage - 1}">
                            <div class="button-container">
                                <img alt="Arrow" src="/images/arrow-down.png" style="max-width: 70px; max-height: 70px; rotate: 180deg">
                            </div>
                        </a>
                    </#if>
                    <#if currentPage < totalPages - 1>
                        <a href="javascript:void(0)" id="nextPage" class="pagination-link" data-page="${currentPage + 1}">
                            <div class="button-container">
                                <img alt="Arrow" src="/images/arrow-down.png" style="max-width: 70px; max-height: 70px;">
                            </div>
                        </a>
                    </#if>
                </div>

            </div>

            <div class="table-container tasks-table">
                <div class="table-wrapper">
                    <table class="table-main">
                        <thead>
                        <tr class="year-month-column">
                            <#list monthsMap?keys as yearMonth>
                                <th class="year-month-th <#if yearMonth_index == 0>first-th<#elseif yearMonth_index == 1>second-th</#if>">
                                    <div class="year-month-header">
                                        <span class="year-month-label">${monthsMap[yearMonth]}</span>
                                    </div>
                                </th>
                            </#list>
                        </tr>
                        </thead>
                        <tbody>
                        <#list list as company>
                            <tr class="table-striped-row task-columns">
                                <#list monthsMap?keys as yearMonth>
                                    <td>
                                        <#if tasksByYearMonthAndCompany[yearMonth]?? && tasksByYearMonthAndCompany[yearMonth][company.id?string]??>
                                            <div class="task-buttons">
                                                <#list tasksByYearMonthAndCompany[yearMonth][company.id?string] as task>
                                                    <button
                                                            class=" task-button"
                                                            onclick="showTaskDetails(this)"
                                                            data-task-id="${task.id}"
                                                            data-document-type="${task.documentTypeName}"
                                                            data-start-date="${task.startDate}"
                                                            data-end-date="${task.endDate}"
                                                            data-company-inn="${task.company.inn}"
                                                            data-company-name="${task.company.name}"
                                                            data-description="${task.description}"
                                                            <#if task.amount??>
                                                                data-amount="${task.amount}"
                                                            <#else>
                                                                data-amount="Не задано"
                                                            </#if>
                                                            data-status="${task.statusId}">
                                                        ${task.documentTypeName}
                                                        <div class="status-indicator <#if task.isCompleted>completed<#else>pending</#if>"></div>
                                                    </button>
                                                </#list>
                                            </div>
                                        <#else>
                                            <span class="no-tasks">Нет задач</span>
                                        </#if>
                                    </td>
                                </#list>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="task-details" class="task-details">
                <input type="hidden" id="csrfToken" value="${(_csrf.token)!'csrf-token'}"/>
                <div class="task-details-header">
                    <h5>Подробнее</h5>
                </div>

                <div id="task-content">

                </div>
            </div>

            <div id="task-create" class="task-create">
                <div class="task-create-header">
                    <h5>Cоздать задачу</h5>
                </div>

                <div id="task-create-content">
                    <div class="task-create-container">

                        <div class="task-create-indicator"></div>
                        <form action="/tasks/create" method="post">
                            <#if _csrf??>
                                <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                                       value="${(_csrf.token)!'csrf-token'}"/>
                            </#if>

                            <div style="position: relative; z-index: 1;">
                                <div class="task-create-document" style="">
                                    <div>
                                        <label for="category" class="task-create-text">Тип документа</label>
                                        <select class="form-select" id="documentType" name="documentTypeId" required>
                                            <#if documentTypeDtos??>
                                                <#list documentTypeDtos as documentType>
                                                    <option value="${documentType.id}">${documentType.name}</option>
                                                </#list>
                                            <#else>
                                                <option disabled>Нет доступных типов документов</option>
                                            </#if>
                                        </select>
                                    </div>

                                </div>
                            </div>


                            <div class="create-task-info">
                                <div id="formPage1" class="form-page">
                                    <div class="task-create-div">
                                        <label for="category" class="task-create-text">Назначить</label>
                                        <select class="form-select" id="user" name="appointToUserId" required>
                                            <#if userDtos??>
                                                <#list userDtos as user>
                                                    <option value="${user.id}">${user.login}</option>
                                                </#list>
                                            <#else>
                                                <option disabled>Нет доступных пользователей</option>
                                            </#if>
                                        </select>
                                    </div>

                                    <div class="task-create-div">
                                        <label for="category" class="task-create-text">Компания</label>
                                        <select class="form-select" id="company" name="companyId" required>
                                            <#if companyDtos??>
                                                <#list companyDtos as company>
                                                    <option value="${company.id}">${company.name}</option>
                                                </#list>
                                            <#else>
                                                <option disabled>Нет доступных компаний</option>
                                            </#if>
                                        </select>
                                    </div>

                                    <div class="task-create-div">
                                        <label for="category" class="task-create-text">Статус</label>
                                        <select class="form-select" id="taskStatus" name="taskStatusId" required>
                                            <#if taskStatusDtos??>
                                                <#list taskStatusDtos as taskStatus>
                                                    <option value="${taskStatus.id}">${taskStatus.name}</option>
                                                </#list>
                                            <#else>
                                                <option disabled>Нет доступных статусов</option>
                                            </#if>
                                        </select>
                                    </div>

                                    <div class="task-create-div" style="margin-top: 50px">
                                        <label for="description" class="task-create-text">Описание</label>
                                        <textarea id="description" name="description" class="task-create-description"></textarea>
                                    </div>

                                    <button type="button" class="btn btn-secondary" id="nextPageCreateTask" onclick="showSecondPage()"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-right-fill" viewBox="0 0 16 16">
                                            <path d="m12.14 8.753-5.482 4.796c-.646.566-1.658.106-1.658-.753V3.204a1 1 0 0 1 1.659-.753l5.48 4.796a1 1 0 0 1 0 1.506z"/>
                                        </svg></button>

                                </div>

                                <div id="formPage2" class="form-page" style="display: none;">

                                    <div>
                                        <p class="task-create-text" style="margin: 0; padding: 0">Выбор периода</p>
                                        <div class="task-create-div">
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="reportType" id="weekly" value="weekly">
                                                <label class="form-check-label" for="weekly">Недельный</label>
                                            </div>

                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="reportType" id="decadal" value="decadal">
                                                <label class="form-check-label" for="decadal">Декадный</label>
                                            </div>

                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="reportType" id="monthly" value="monthly" checked>
                                                <label class="form-check-label" for="monthly">Ежемесячный</label>
                                            </div>

                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="reportType" id="quarterly" value="quarterly">
                                                <label class="form-check-label" for="quarterly">Ежеквартальный</label>
                                            </div>

                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="reportType" id="annual" value="annual">
                                                <label class="form-check-label" for="annual">Годовой</label>
                                            </div>
                                        </div>

                                        <div class="task-create-div task-create-week-decade-month-selection">
                                            <div id="weekSelection" style="display: none;">
                                                <label for="week" class="task-create-text">Неделя</label>
                                                <select class="form-select" id="week">
                                                    <option value="">Выберите неделю</option>
                                                    <option value="1">1 неделя</option>
                                                    <option value="2">2 неделя</option>
                                                    <option value="3">3 неделя</option>
                                                    <option value="4">4 неделя</option>
                                                </select>
                                            </div>
                                            <div id="decadeSelection" style="display:none;">
                                                <label for="decade" class="task-create-text">Декада</label>
                                                <select class="form-select" id="decade" name="decade">
                                                    <option value="">Выберите декаду</option>
                                                    <option value="1">1-я декада</option>
                                                    <option value="2">2-я декада</option>
                                                    <option value="3">3-я декада</option>
                                                </select>
                                            </div>

                                            <div id="quarterSelection" style="display: none;">
                                                <label for="quarter" class="task-create-text">Квартал</label>
                                                <select class="form-select" id="quarter" name="quarter">
                                                    <option value="">Выберите квартал</option>
                                                    <option value="1">1 квартал</option>
                                                    <option value="2">2 квартал</option>
                                                    <option value="3">3 квартал</option>
                                                    <option value="4">4 квартал</option>
                                                </select>
                                            </div>
                                            <div id="monthSelection" style="display: none">
                                                <label for="month" class="task-create-text">Месяц</label>
                                                <select class="form-select" id="month" name="month">
                                                    <option value="">Выберите месяц</option>
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
                                        </div>

                                        <div class="task-create-div">
                                            <label for="year" class="task-create-text">Год</label>
                                            <select class="form-select" id="year">
                                                <option value="">Выберите год</option>
                                                <option value="2023">2023</option>
                                                <option value="2024">2024</option>
                                                <option value="2025">2025</option>
                                                <option value="2026">2026</option>
                                                <option value="2027">2027</option>
                                                <option value="2028">2028</option>
                                                <option value="2029">2029</option>
                                                <option value="2030">2030</option>
                                            </select>
                                        </div>

                                        <div class="task-create-div">
                                            <label for="startDate" class="task-create-text">Дата начала</label>
                                            <input type="text" class="form-control" id="startDateDisplay" readonly>
                                            <input type="hidden" id="startDate" name="startDate">
                                        </div>

                                        <div class="task-create-div">
                                            <label for="endDate" class="task-create-text">Дата окончания</label>
                                            <input type="text" class="form-control" id="endDateDisplay" readonly>
                                            <input type="hidden" id="endDate" name="endDate">
                                        </div>
                                    </div>
                                    <div style="display: flex; justify-content: center; margin-top: 50px">
                                        <button
                                                class="button-save-create-task"
                                                style="cursor: not-allowed; opacity: 0.5;"
                                                disabled>
                                            <svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" fill="currentColor" class="bi bi-cloud-plus-fill" viewBox="0 0 16 16">
                                                <path d="M8 2a5.53 5.53 0 0 0-3.594 1.342c-.766.66-1.321 1.52-1.464 2.383C1.266 6.095 0 7.555 0 9.318 0 11.366 1.708 13 3.781 13h8.906C14.502 13 16 11.57 16 9.773c0-1.636-1.242-2.969-2.834-3.194C12.923 3.999 10.69 2 8 2m.5 4v1.5H10a.5.5 0 0 1 0 1H8.5V10a.5.5 0 0 1-1 0V8.5H6a.5.5 0 0 1 0-1h1.5V6a.5.5 0 0 1 1 0"/>
                                            </svg>
                                        </button>
                                    </div>



                                    <button type="button" class="btn btn-secondary" id="prevPageCreateTask" onclick="showFirstPage()"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-left-fill" viewBox="0 0 16 16">
                                            <path d="m3.86 8.753 5.482 4.796c.646.566 1.658.106 1.658-.753V3.204a1 1 0 0 0-1.659-.753l-5.48 4.796a1 1 0 0 0 0 1.506z"/>
                                        </svg>
                                    </button>

                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <script>
        const taskStatusDtos = ${taskStatusDtosJson?no_esc};
    </script>
    <script>
        const availableYearMonths = ${availableYearMonthsJson?no_esc};
    </script>
    <script src="/js/list.js"></script>
    <script src="/js/taskDateLogic.js"></script>
    <input type="hidden" id="openModal" value="${openModal?string('true', 'false')}">

    <style>
        .container {
            padding: 1rem;
            transition: all 0.3s ease;
        }
        .main-content {
            display: flex;
            width: 100%;
        }

        .table-container {
            position: relative;
        }
        .company-table {
            width: 244px;
            overflow: hidden;
            margin-right: 5px;
            background-color: #d9d9d9;

            transition: width 0.3s ease, padding 0.3s ease;
        }

        .company-column-tr{
            background-color: #ffffff;
            height: 61px;
        }
        .tasks-table {
            width: 100%;
            background-color: #d9d9d9;
            flex: 1;
            margin-right: 10px;
            margin-top: 26px;
            box-sizing: border-box;

        }
        .year-month-column {
            background-color: #ffffff;
            height: 35px;

        }

        .year-month-th {
            padding: 5px;

        }

        .year-month-th.first-th {
            background-color: #d9d9d9;
        }

        .year-month-th.second-th {
            background-color: #ededed;
            border-right: 2px solid #c8c8c8;
        }

        .table-wrapper {
            width: 100%;
            margin-bottom: 1rem;
            height: 550px;
            min-height: 550px;
            max-height: 550px;
        }

        .table-main {
            width: 100%;
            margin-bottom: 20px;

        }

        .table-main th {
            text-align: center;
            border-bottom: 1px solid #dee2e6;
        }

        .table-main td {
            text-align: center;
            border-bottom: 3px solid #a4a4a4;
            box-shadow: 0 4px 2px -2px #a4a4a4;
        }
        .table-main {
            background-color: #d9d9d9;

        }

        .company-columns {
            text-align: center;
            height: 52px;
        }
        .task-columns {
            height: 52px;

        }

        .table-striped-row:nth-child(odd) {
            background-color: #d9d9d9;

        }
        .table-striped-row:nth-child(even) {
            background-color: #ffffff;
        }

        .task-buttons {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }

        .task-button {
            margin-right: 4px;
            margin-left: 4px;
            position: relative;
            font-size: 12px;
            border: 1px solid #ffffff;
            border-radius: 4px;
            width: 133px;
            height: 45px;
            overflow: hidden;

            box-shadow: -1px 0px 2px rgba(0, 0, 0, 0.3),
            0px 2px 5px rgba(0, 0, 0, 0.4);
        }

        .task-button:hover {
            background-color: #e0e0e0;
            transition: background-color 0.3s ease;
            cursor: pointer;
        }
        .button-alert {
            position: absolute;

        }

        .completed {
            background-color: #15C24E;
        }

        .pending {
            background-color: #C20B18;
        }

        .task-details {
            width: 0;
            overflow: hidden;
            padding: 0;
            transition: width 0.3s ease, padding 0.3s ease;
        }

        .container.with-details .task-details {
            width: 30%;
            border: 1px solid #dee2e6;
        }

        .task-details-header {
            position: relative;
            height: 61px;
            background-color: #ffffff;
            display: flex;
            align-items: center;
            font-size: 18px;
            font-weight: bold;
            text-align: center;
            color: #333;
            justify-content: center;
        }

        .no-tasks {
            font-style: italic;
            color: #6c757d;
        }

        .task-create {
            width: 0;
            overflow: hidden;
            padding: 0;
            transition: width 0.3s ease, padding 0.3s ease;
        }

        .task-create-header {
            position: relative;
            height: 61px;
            background-color: #ffffff;
            display: flex;
            align-items: center;
            font-size: 18px;
            font-weight: bold;
            text-align: center;
            color: #333;
            justify-content: center;
        }

        .task-create-container {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 4px;
            position: relative;
            overflow: hidden;

            height: 610px;
        }

        .task-create-indicator {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 8px;
            background-color: mediumpurple;
            pointer-events: none;
            z-index: 0;
        }

        #task-create-content {
            padding: 5px;
            background-color: #d9d9d9;
            width: 100%;
            height: 100%;
        }

        .task-create-description {
            width: 324px;
            height: 112px;
            background-color: #d9d9d9;
            color: #333;
            padding: 10px;
            border: none;
            border-radius: 8px;
            box-shadow: inset 2px 2px 5px rgba(0, 0, 0, 0.2), inset -2px -2px 5px rgba(255, 255, 255, 0.5);
            outline: none;
            font-size: 16px;
            resize: none;
            overflow-y: auto;
        }

        .task-create-text {
            font-size: 14px; font-style: italic; font-weight: 100
        }

        .task-create-document {
            display: flex;
            justify-content: center;
            margin-bottom: 25px;
        }

        .task-create-div {
            margin-bottom: 10px;
        }

        .task-create-week-decade-month-selection {
            display: flex;
            flex-direction: row;
            gap: 10px;
        }

        .form-page {
            width: 100%;
            transition: transform 0.3s ease, opacity 0.3s ease;
            position: relative;
        }

        #formPage1 {
            height: 495px;
        }

        #formPage2 {
            height: 495px;
        }

        #nextPageCreateTask {
            position: absolute;
            bottom: 10px;
            left: 10px;
        }

        #prevPageCreateTask {
            position: absolute;
            bottom: 10px;
            left: 10px;
        }

        .button-save-create-task {
            background-color: #ECE6F0;
            height: 51px;
            width: 219px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: -1px 0px 2px rgba(0, 0, 0, 0.3), 0px 2px 5px rgba(0, 0, 0, 0.4);
        }

        @keyframes slide-in-right {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slide-out-left {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(-100%);
                opacity: 0;
            }
        }

        @keyframes slide-in-left {
            from {
                transform: translateX(-100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slide-out-right {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }

        .slide-in-right {
            animation: slide-in-right 0.3s forwards;
        }

        .slide-out-left {
            animation: slide-out-left 0.3s forwards;
        }

        .slide-in-left {
            animation: slide-in-left 0.3s forwards;
        }

        .slide-out-right {
            animation: slide-out-right 0.3s forwards;
        }

        .pagination-container{
            display: flex;
            justify-content: end;
            align-items: center;
            flex-direction: column;
            width: 244px;
            height: 150px;

            transition: all 0.3s ease;
        }

        .button-container {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 237px;
            height: 70px;
            background-color: #f9f9f9;
            border-radius: 8px;
            border: 1px solid #ddd;
            margin-bottom: 4px;
            box-shadow: -1px 0px 2px rgba(0, 0, 0, 0.3);
        }
        .button-container:hover {
            background-color: #e0e0e0;
            transition: background-color 0.3s ease;
            cursor: pointer;
        }

        .status-indicator {
            position: absolute;
            top: 0;
            right: 0;
            width: 23px;
            height: 100%;
            pointer-events: none;
        }

        #task-content {
            padding: 5px;
            background-color: #d9d9d9;
            width: 100%;
            height: 100%;
        }


        #task-edit-form p {
            font-size: 16px;
            margin: 5px 0;
            color: #333;
        }

        #task-edit-form strong {
            color: #666;
            font-style: italic;
        }

        textarea, input[type="text"] {
            width: 100%;
            border-radius: 5px;
            border: 1px solid #ccc;
            padding: 10px;
            font-size: 16px;
            margin-bottom: 10px;
        }

        button[type="submit"] {
            display: inline-block;
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button[type="submit"]:hover {
            background-color: #45a049;
        }

        .task-info {
            display: flex;
            margin-bottom: 20px;
        }

        .labels {
            text-align: right;
            width: 30%;
            padding-right: 10px;
            font-size: 14px;
            font-style: italic;
            color: #555;
        }

        .values {
            text-align: left;
            width: 70%;
            font-size: 16px;
            font-weight: 400;
            color: #000;
        }

        .task-info p {
            margin: 5px 0;
        }

        .year-month-header {
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
        }

        .year-month-label {
            padding: 0 20px;
            white-space: nowrap;
            font-weight: bold;
            font-size: 14px;

        }

        .year-month-navigation button {
            pointer-events: auto;
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .year-month-navigation button:hover {
            background-color: #0056b3;
        }

        .year-month-navigation .btn-nav:first-of-type {
            margin-right: auto;
        }

        .year-month-navigation .btn-nav:last-of-type {
            margin-left: auto;
        }

        .btn-nav {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn-nav:hover {
            background-color: #0056b3;
        }

        #currentYearMonth {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }


        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }
        .alert-danger {
            color: #a94442;
            background-color: #f2dede;
            border-color: #ebccd1;
        }
        .alert p {
            margin: 0;
        }

        .collapse-button {
            margin-bottom: 10px;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .collapse-button:hover {
            opacity: 0.8;
            transform: scale(1.1);
        }

        .btn-collapse-task-details {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            transition: opacity 0.3s ease, transform 0.2s ease;
        }

        .btn-collapse-task-details:hover {
            opacity: 0.8;
            transform: scale(1.1);
        }

        .btn-save-task:hover {
            opacity: 0.8;
            transition: background-color 0.3s ease;
            cursor: pointer;
        }

        .btn-nav-img-toggle:hover {
            opacity: 0.8;
            transform: scale(1.1);
        }




    </style>
    <input type="hidden" id="openModal" value="${openModal?string('true', 'false')}">
</@layout.layout>
