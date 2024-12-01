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
        </div>
    </div>


    <script>
        const taskStatusDtos = ${taskStatusDtosJson?no_esc};
    </script>
    <script>
        const availableYearMonths = ${availableYearMonthsJson?no_esc};
    </script>
    <script src="/js/list.js"></script>


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
            min-width: 244px;
            max-width: 244px;

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

        .no-tasks {
            font-style: italic;
            color: #6c757d;
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
</@layout.layout>
