#Использовать json

// Хранит экземпляр текущего хранилища данных
Перем ХранилищеДанных;

// Хранит экземпляр текущего провайдера интеграции
Перем ПровайдерИнтеграции;

// Путь к каталогу, в котором располагаются файлы с данными
Перем Каталог;

Функция ХранилищеДанных() Экспорт
	
	Возврат МенеджерХранилищаОшибок.Инициализировать (ХранилищеДанных, Каталог);
	
КонецФункции

Процедура УстановитьХранилищеДанных(вхХранилищеДанных) Экспорт
	
	ХранилищеДанных = вхХранилищеДанных;
	
КонецПроцедуры

Функция ПровайдерИнтеграции() Экспорт
	
	Возврат ПровайдерИнтеграции;
	
КонецФункции

Процедура УстановитьПровайдерИнтеграции(вхПровайдерИнтеграции) Экспорт
	
	ПровайдерИнтеграции = вхПровайдерИнтеграции;
	
КонецПроцедуры

Процедура Инициализировать(ПутьКФайлу = "") Экспорт
	
	Если Не ЗначениеЗаполнено(ПутьКФайлу) Тогда
		ПутьКФайлу = "appsettings.json";
	КонецЕсли;

	Настройки = ПрочитатьФайлНастроекПриложения(ПутьКФайлу);

	НастроитьХранилищеДанных(Настройки);
	НастроитьПровайдерИнтеграции(Настройки);
	
КонецПроцедуры

Функция ПрочитатьФайлНастроекПриложения(ПутьКФайлу)
	
	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлу, "utf-8");
	СодержимоеФайлаНастроек = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	
	ПарсерJSON = Новый ПарсерJSON();
	Настройки = ПарсерJSON.ПрочитатьJSON(СодержимоеФайлаНастроек);
	
	Возврат Настройки["reperrSettings"];
	
КонецФункции

Процедура НастроитьХранилищеДанных(Настройки)

	ВидыХранилищ = Настройки["DataStorage"];
	
	Для Каждого ВидХранилища Из ВидыХранилищ Цикл
		
		ВидХранилищаНастройки = ВидХранилища.Значение;
		
		Если ВидХранилищаНастройки["enabled"] Тогда
			
			Если ВидХранилища.Ключ = "file" Тогда
				Каталог = ВидХранилищаНастройки["path"];	
				ХранилищеДанных = Новый ФайловоеХранилище(Каталог);
			ИначеЕсли ВидХранилища.Ключ = "dbase" Тогда
				Каталог = ВидХранилищаНастройки["path"];	
				ТипХранилища = ВидХранилищаНастройки["type"];	
				ХранилищеДанных = Новый ХранилищеБазыДанных (ТипХранилища);
			Иначе
				ВызватьИсключение("Неизвестный тип хранения данных, проверьте файл настроек appsettings.json");
			КонецЕсли;
			
			Прервать;
		КонецЕсли;
		
	КонецЦикла;

	Если ХранилищеДанных = Неопределено Тогда
		ВызватьИсключение "Не определен тип хранения данных! Проверьте файл настроек appsettings.json";
	КонецЕсли;

КонецПроцедуры

Процедура НастроитьПровайдерИнтеграции(Настройки)

	Интеграции = Настройки["Integrations"];
	
	Для Каждого Интеграция Из Интеграции Цикл

		ИнтеграцияНастройки = Интеграция.Значение;
	
		Если ИнтеграцияНастройки["enabled"] Тогда
	
			Если Интеграция.Ключ = "redmine" Тогда

				ПровайдерИнтеграцииRedmine = Новый ПровайдерИнтеграцииRedmine()
												.URLRedmine(ИнтеграцияНастройки["url"])
												.КлючAPI(ИнтеграцияНастройки["APIKey"])
												.ИдПроекта(ИнтеграцияНастройки["project-id"])
												.ИдТрекера(ИнтеграцияНастройки["tracker-id"])
												.ИдПриоритета(ИнтеграцияНастройки["priority-id"])
												.ИдСтатуса(ИнтеграцияНастройки["status-id"])
												.Тема(ИнтеграцияНастройки["topic"])
												.КоличествоЧасов(ИнтеграцияНастройки["hours"])
												;

				ПровайдерИнтеграции = ПровайдерИнтеграцииRedmine;

			ИначеЕсли Интеграция.Ключ = "jira" Тогда

				ПровайдерИнтеграцииJira = Новый ПровайдерИнтеграцииJira()
												.URL(ИнтеграцияНастройки["url"])
												.Логин(ИнтеграцияНастройки["login"])
												.Токен(ИнтеграцияНастройки["token"])
												.КлючПроекта(ИнтеграцияНастройки["project-key"])
												.ИдТипаЗадачи(ИнтеграцияНастройки["issuetype-id"])
												.ТемаЗадачи(ИнтеграцияНастройки["summary"])
												.СрокИсполнения(ИнтеграцияНастройки["term"])
												;

				ПровайдерИнтеграции = ПровайдерИнтеграцииJira;
			
			ИначеЕсли Интеграция.Ключ = "rabbitMQ" Тогда

				ПровайдерИнтеграцииRabbitMQ = Новый ПровайдерИнтеграцииRabbitMQ()
												.Пользователь(ИнтеграцияНастройки["user"])
												.Пароль(ИнтеграцияНастройки["password"])
												.Сервер(ИнтеграцияНастройки["server"])
												.ВиртуальныйХост(ИнтеграцияНастройки["vhost"])
												.ИмяТочкиОбмена(ИнтеграцияНастройки["exchange"])
												;

				ПровайдерИнтеграции = ПровайдерИнтеграцииRabbitMQ;

			ИначеЕсли Интеграция.Ключ = "sentry" Тогда

				ПровайдерИнтеграцииSentry = Новый ПровайдерИнтеграцииSentry()
												.DSN(ИнтеграцияНастройки["dsn"])
												.КлючAPI(ИнтеграцияНастройки["secret"])
												.Логгер(ИнтеграцияНастройки["logger"])
												;

				ПровайдерИнтеграции = ПровайдерИнтеграцииSentry;

			Иначе
				ВызватьИсключение("Неизвестный тип интеграции");
			КонецЕсли;

			Прервать;

		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры
