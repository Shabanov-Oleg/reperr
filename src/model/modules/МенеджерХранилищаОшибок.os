#Использовать fs

// Хранит экземпляр текущего хранилища данных
Перем ХранилищеДанных;

// Путь к каталогу, в котором располагаются файлы с данными
Перем Каталог;

Функция Инициализировать (мХранилищеДанных, мКаталогДанных) Экспорт
	ХранилищеДанных = мХранилищеДанных;
	Каталог = мКаталогДанных;
	Возврат ЭтотОбъект;
КонецФункции

Функция ПолучитьЗапросыИнфоОбОшибках() Экспорт

	Результат = ТаблицаЗапросовИнфоОбОшибках();

	ЗапросыИнфоОбОшибках = ХранилищеДанных.ПрочитатьЗапросыИнфоОбОшибках ();
	Если ЗапросыИнфоОбОшибках = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;

	Для Каждого ЗапросИнфоПоОшибке Из ХранилищеДанных.ПрочитатьЗапросыИнфоОбОшибках () Цикл
		нСтр = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(нСтр, ЗапросИнфоПоОшибке);
	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция ТаблицаЗапросовИнфоОбОшибках()

	Таблица = Новый ТаблицаЗначений;

	Таблица.Колонки.Добавить("x_id");
	Таблица.Колонки.Добавить("x_datetime");
	Таблица.Колонки.Добавить("x_fingerprint");
	
	Таблица.Колонки.Добавить("configHash");
	Таблица.Колонки.Добавить("сonfigName");
	Таблица.Колонки.Добавить("configVersion");
	Таблица.Колонки.Добавить("appStackHash");
	Таблица.Колонки.Добавить("clientStackHash");
	Таблица.Колонки.Добавить("serverStackHash");
	Таблица.Колонки.Добавить("platformType");
	Таблица.Колонки.Добавить("appName");
	Таблица.Колонки.Добавить("appVersion");
	Таблица.Колонки.Добавить("configurationInterfaceLanguageCode");
	Таблица.Колонки.Добавить("systemcrash");

	Возврат Таблица;

КонецФункции

Процедура ЗаписатьЗапросИнфоОбОшибке(ЗапросИнфоОбОшибке) Экспорт
	ХранилищеДанных.ЗаписатьЗапросИнфоОбОшибке (ЗапросИнфоОбОшибке);
КонецПроцедуры

Функция ПолучитьОшибки() Экспорт
	
	Результат = ТаблицаОшибок();

	Ошибки = ХранилищеДанных.ПрочитатьОшибки ();
	Если Ошибки = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;

	Для Каждого Ошибка Из ХранилищеДанных.ПрочитатьОшибки () Цикл
		нСтр = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(нСтр, Ошибка);
	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция ИдентификаторОшибкиВТрекереПоОтпечатку(Отпечаток) Экспорт
	Возврат ХранилищеДанных.ИдентификаторОшибкиВТрекереПоОтпечатку(Отпечаток);
КонецФункции

Функция ТаблицаОшибок()

	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("datetime");
	Таблица.Колонки.Добавить("fingerprint");
	Таблица.Колонки.Добавить("external_id");

	Возврат Таблица;

КонецФункции

Процедура СохранитьФайлОтчета(Идентификатор, ФайлОтчета) Экспорт

	ИмяФайлаОтчета = СтрШаблон("%1.zip", Идентификатор);
	ИмяАрхива = ОбъединитьПути(Каталог, ИмяФайлаОтчета);
	
	ПотокВходящегоФайла = ФайлОтчета.ОткрытьПотокДляЧтения();

	// ФайловыйПоток нужен здесь потому, что ЧтениеZipФайла в OneScript 1.4 не умеет читать Поток
	ФайловыйПоток = ФайловыеПотоки.ОткрытьДляЗаписи(ИмяАрхива);
	ПотокВходящегоФайла.КопироватьВ(ФайловыйПоток);
	ПотокВходящегоФайла.Закрыть();
	ФайловыйПоток.Закрыть();

	ЧтениеZIP = Новый ЧтениеZipФайла(ИмяАрхива);
	КаталогОтчета = ОбъединитьПути(Каталог, Идентификатор);
	ЧтениеZIP.ИзвлечьВсе(КаталогОтчета);
	ЧтениеZIP.Закрыть();

	УдалитьФайлы(ИмяАрхива);

КонецПроцедуры

Функция ОтпечатокОшибки(ОтчетОбОшибке)

	СистемнаяИнфоОбОшибке = ОтчетОбОшибке["errorInfo"]["systemErrorInfo"];
	ПрограммнаяИнфоОбОшибке = ОтчетОбОшибке["errorInfo"]["applicationErrorInfo"];

	Провайдер = Новый ХешированиеДанных(ХешФункция.MD5);

	stackHash = ПрограммнаяИнфоОбОшибке ["stackHash"];
	Если ЗначениеЗаполнено (stackHash) Тогда
		Провайдер.Добавить (stackHash);
	Иначе

		clientStackHash = СистемнаяИнфоОбОшибке["clientStackHash"];
		Если ЗначениеЗаполнено(clientStackHash) Тогда
			Провайдер.Добавить(clientStackHash);
		КонецЕсли;
	
		serverStackHash = СистемнаяИнфоОбОшибке["serverStackHash"];
		Если ЗначениеЗаполнено(serverStackHash) Тогда
			Провайдер.Добавить(serverStackHash);
		КонецЕсли;
	
	КонецЕсли;

	Возврат Провайдер.ХешСуммаСтрокой;

КонецФункции

Функция ПолучитьДанныеОтчетаОбОшибке(Знач ИдОтчетаОбОшибке) Экспорт

	Результат = СтруктураДанныхОтчетаОбОшибке();

	КаталогОтчета = ОбъединитьПути(Каталог, ИдОтчетаОбОшибке);
	ФайлыАрхива = НайтиФайлы(КаталогОтчета, "*", Истина);

	Если ФайлыАрхива.Количество() = 0 Тогда
		ТекстИсключения = СтрШаблон("Не удалось найти отчет об ошибке Ид %1", ИдОтчетаОбОшибке);
		ВызватьИсключение(ТекстИсключения);
	КонецЕсли;

	Для Каждого Файл Из ФайлыАрхива Цикл

		Если Файл.Имя = "report.json" Тогда
			ЗаполнитьОтчетОбОшибке(Результат, Файл.ПолноеИмя);
		ИначеЕсли Файл.Имя = "screenshot.png" Тогда
			Результат.Скриншот = Файл.ПолноеИмя;
		Иначе
			Результат.Файлы.Добавить(Файл.ПолноеИмя);
		КонецЕсли;

	КонецЦикла;

	Возврат Результат;

КонецФункции

Процедура ЗаполнитьОтчетОбОшибке(СтруктураОтчета, ИмяФайла) Экспорт
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
	ОтчетОбОшибкеJSON = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	
	ПарсерJSON = Новый ПарсерJSON;
	ДанныеОтчетаОбОшибке = ПарсерJSON.ПрочитатьJSON(ОтчетОбОшибкеJSON);

	СтруктураОтчета.Отчет = ДанныеОтчетаОбОшибке;
	
КонецПроцедуры

Функция СтруктураДанныхОтчетаОбОшибке() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Идентификатор", "");
	Результат.Вставить("Отчет", Неопределено);
	Результат.Вставить("Файлы", Новый Массив());
	Результат.Вставить("Скриншот", "");
	
	Возврат Результат;
	
КонецФункции

Функция ОбработатьОтчетОбОшибке(ФайлОтчета) Экспорт

	Идентификатор = Строка(Новый УникальныйИдентификатор());
	СохранитьФайлОтчета(Идентификатор, ФайлОтчета);

	ДанныеОтчетаОбОшибке = ПолучитьДанныеОтчетаОбОшибке(Идентификатор);
	ДанныеОтчетаОбОшибке.Идентификатор = ОтпечатокОшибки (ДанныеОтчетаОбОшибке.Отчет);
	ХранилищеДанных.ЗаписатьОшибку(ДанныеОтчетаОбОшибке);
	
	ПереименоватьПапку (ОбъединитьПути (Каталог, Идентификатор), ОбъединитьПути (Каталог, ДанныеОтчетаОбОшибке.Идентификатор));
	ИзменитьПутиКФайламОтчета (ДанныеОтчетаОбОшибке);

	Возврат ДанныеОтчетаОбОшибке;

КонецФункции

Процедура ИзменитьПутиКФайламОтчета (ДанныеОтчетаОбОшибке)

	КаталогФайлов = ОбъединитьПути (Каталог, ДанныеОтчетаОбОшибке.Идентификатор);

	Если Не ПустаяСтрока (ДанныеОтчетаОбОшибке.Скриншот) Тогда
		Файл = Новый Файл (ДанныеОтчетаОбОшибке.Скриншот);
		ДанныеОтчетаОбОшибке.Скриншот = ОбъединитьПути (КаталогФайлов, Файл.Имя);
	КонецЕсли;

	Для инд = 0 По ДанныеОтчетаОбОшибке.Файлы.ВГраница () Цикл
		ИмяФайла = ДанныеОтчетаОбОшибке.Файлы [инд];
		Файл = Новый Файл (ИмяФайла);
		ДанныеОтчетаОбОшибке.Файлы [инд] = ОбъединитьПути (КаталогФайлов, Файл.Имя);
	КонецЦикла;

КонецПроцедуры

// Выполняет поштучное перемещение файлов из папки Источник
// в папку Приемник (создает ее, если нет).
// Прим. стандартный метод ПереместитьФайл для каталога не отрабатывает
Процедура ПереименоватьПапку (Источник, Приемник)

	Папка = Новый Файл (Приемник);
	Если Не Папка.Существует () Или Не Папка.ЭтоКаталог () Тогда
		СоздатьКаталог (Приемник);
	КонецЕсли;

	НайденныеФайлы = НайтиФайлы (Источник, "*.*");
	Для Каждого Файл Из НайденныеФайлы Цикл
		Если Файл.ЭтоКаталог () Тогда
			Продолжить;
		КонецЕсли;
		ПереместитьФайл (Файл.ПолноеИмя, ОбъединитьПути (Приемник, Файл.Имя));
	КонецЦикла;

	УдалитьФайлы (Источник);

КонецПроцедуры

Процедура УстановитьИдЗадачиВТрекере(ИдентификаторЗадачи, ИдЗадачиВТрекере) Экспорт
	ХранилищеДанных.УстановитьИдЗадачиВТрекере (ИдентификаторЗадачи, ИдЗадачиВТрекере);
КонецПроцедуры
