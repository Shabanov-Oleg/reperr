#Использовать fs

// Путь к каталогу, в котором располагаются файлы с данными
Перем Каталог;

// Имя файла внутри каталога с данными, в который записывается
// информация о полученных запросах информации об ошибках
Перем ИмяФайлаЗапросыИнфоОбОшибке;

// Имя файла внутри каталога с данными, в который записывается
// информация о зарегистрированных ошибках
Перем ИмяФайлаЗарегистрированныеОшибки;

Процедура ПриСозданииОбъекта(вхКаталог) Экспорт

	Каталог = вхКаталог;

	ИмяФайлаЗапросыИнфоОбОшибке = ОбъединитьПути(Каталог, "errorInfoRequests.json");
	ИмяФайлаЗарегистрированныеОшибки = ОбъединитьПути(Каталог, "errors.json");

	Если Не ФС.КаталогСуществует(Каталог) Тогда
		
		ФС.ОбеспечитьКаталог(Каталог);

		СоздатьФайл(ИмяФайлаЗапросыИнфоОбОшибке);
		СоздатьФайл(ИмяФайлаЗарегистрированныеОшибки);
		
	КонецЕсли;

КонецПроцедуры

Процедура СоздатьФайл(ИмяФайла)

	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, "utf-8");
	ЗаписьТекста.Записать("");
	ЗаписьТекста.Закрыть();

КонецПроцедуры

Функция ПолучитьЗапросыИнфоОбОшибках() Экспорт

	Результат = ТаблицаЗапросовИнфоОбОшибках();

	ЧтениеJSON = Новый ЧтениеJSON();
	
	ЧтениеJSON.ОткрытьФайл(ИмяФайлаЗапросыИнфоОбОшибке, "utf-8");
	Запросы = ПрочитатьJSON(ЧтениеJSON, Ложь);	
	ЧтениеJSON.Закрыть();

	Если Запросы = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;

	Для Каждого ЗапросИнфоПоОшибке Из Запросы Цикл

		нСтр = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(нСтр, ЗапросИнфоПоОшибке);

	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция ТаблицаЗапросовИнфоОбОшибках()

	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("id");
	Таблица.Колонки.Добавить("datetime");
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

	ТЗ = ПолучитьЗапросыИнфоОбОшибках();

	нСтр = ТЗ.Добавить();
	ЗаполнитьЗначенияСвойств(нСтр, ЗапросИнфоОбОшибке);
	нСтр.id = Строка(Новый УникальныйИдентификатор());
	нСтр.datetime = ТекущаяУниверсальнаяДата();
	
	Текст = Новый ЗаписьТекста(ИмяФайлаЗапросыИнфоОбОшибке);
	ПарсерJSON = Новый ПарсерJSON;
	Текст.Записать(ПарсерJSON.ЗаписатьJSON(ТЗ));
	Текст.Закрыть();

КонецПроцедуры

Функция ПолучитьЗарегистрированныеОшибки() Экспорт
	
	Результат = ТаблицаЗарегистрированныхОшибок();

	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.ОткрытьФайл(ИмяФайлаЗарегистрированныеОшибки, "utf-8");
	ТаблицаЗарегистрированныеОшибки = ПрочитатьJSON(ЧтениеJSON, Ложь);	
	ЧтениеJSON.Закрыть();

	Если ТаблицаЗарегистрированныеОшибки = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;

	Для Каждого ЗарегистрированнаяОшибка Из ТаблицаЗарегистрированныеОшибки Цикл

		нСтр = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(нСтр, ЗарегистрированнаяОшибка);

	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция ТаблицаЗарегистрированныхОшибок()

	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("id");
	Таблица.Колонки.Добавить("datetime");

	Возврат Таблица;

КонецФункции

Процедура СохранитьФайлОтчета(ИдОтчетаОбОшибке, ФайлОтчета) Экспорт

	ИмяАрхива = ОбъединитьПути(Каталог, ИдОтчетаОбОшибке + ".zip");
	
	ПотокВходящегоФайла = ФайлОтчета.ОткрытьПотокДляЧтения();

	ФайловыйПоток = ФайловыеПотоки.ОткрытьДляЗаписи(ИмяАрхива);
	ПотокВходящегоФайла.КопироватьВ(ФайловыйПоток);
	ПотокВходящегоФайла.Закрыть();
	ФайловыйПоток.Закрыть();

	ЧтениеZIP = Новый ЧтениеZipФайла(ИмяАрхива);
	КаталогОтчета = ОбъединитьПути(Каталог, ИдОтчетаОбОшибке);
	ЧтениеZIP.ИзвлечьВсе(КаталогОтчета);
	ЧтениеZIP.Закрыть();

	УдалитьФайлы(ИмяАрхива);

КонецПроцедуры

Процедура ЗаписатьИнформациюОбОшибке(Знач ИдОтчетаОбОшибке) Экспорт

	ТЗ = ПолучитьЗарегистрированныеОшибки();

	нСтр = ТЗ.Добавить();
	нСтр.id = ИдОтчетаОбОшибке;
	нСтр.datetime = ТекущаяУниверсальнаяДата();
	
	Текст = Новый ЗаписьТекста(ИмяФайлаЗарегистрированныеОшибки);
	ПарсерJSON = Новый ПарсерJSON;
	Текст.Записать(ПарсерJSON.ЗаписатьJSON(ТЗ));
	Текст.Закрыть();

КонецПроцедуры

Функция ПолучитьДанныеОтчетаОбОшибке(Знач ИдОтчетаОбОшибке) Экспорт

	Результат = ОтчетыОбОшибках.СтруктураДанныхОтчетаОбОшибке();

	КаталогОтчета = ОбъединитьПути(Каталог, ИдОтчетаОбОшибке);
	ФайлыАрхива = НайтиФайлы(КаталогОтчета, "*", Истина);

	Для Каждого Файл Из ФайлыАрхива Цикл

		Если Файл.Имя = "report.json" Тогда
			ОтчетыОбОшибках.ЗаполнитьОтчетОбОшибке(Результат, Файл.ПолноеИмя);
		ИначеЕсли Файл.Имя = "screenshot.png" Тогда
			Результат.Скриншот = Файл.ПолноеИмя;
		Иначе
			Результат.Файлы.Добавить(Файл.ПолноеИмя);
		КонецЕсли;

	КонецЦикла;

	Возврат Результат;

КонецФункции
