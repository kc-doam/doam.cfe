﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервереРедакцииКонфигурации();
	
	ВестиУчетСканКопийОригиналовДокументов = 
		ПолучитьФункциональнуюОпцию("ВестиУчетСканКопийОригиналовДокументов");
	
	Если Параметры.Свойство("Папка") Тогда 
		Папка = Параметры.Папка;
	КонецЕсли;	
	
	Если Параметры.Свойство("Файлы") Тогда 
		МассивФайлов = Параметры.Файлы;
		Для Каждого ИмяФайла Из МассивФайлов Цикл
			ФайлПеренесенный = Новый Файл(ИмяФайла);
			
			НовыйЭлемент = Файлы.Добавить();
			НовыйЭлемент.ИмяФайла = ФайлПеренесенный.ИмяБезРасширения;
			НовыйЭлемент.ПутьФайла = ФайлПеренесенный.Путь;
			НовыйЭлемент.ПолноеИмя = ФайлПеренесенный.ПолноеИмя;
			НовыйЭлемент.ИндексКартинки = ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(ФайлПеренесенный.Расширение);
			
			Если ДелопроизводствоКлиентСервер.ЭтоРасширениеСканКопии(ФайлПеренесенный.Расширение) Тогда 
				НовыйЭлемент.Оригинал = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;	
	
	КоличествоФайлов = Файлы.Количество();
	Заголовок = СформироватьЗаголовок(КоличествоФайлов);
	
	Подготовил = ПользователиКлиентСервер.ТекущийПользователь();
	ЭтоДелопроизводитель = РольДоступна("РегистрацияВнутреннихДокументов") Или РольДоступна("ПолныеПрава");
	Если ЭтоДелопроизводитель Тогда 
		РегистрироватьДокументы = Истина;
		ДатаРегистрации = "ТекущаяДата";
		ДатаРегистрацииДокументов = ТекущаяДата();
	Иначе 
		РегистрироватьДокументы = Ложь;
		Элементы.ГруппаРегистрация.Видимость = Ложь; 
	КонецЕсли;	
	
	// распознавание
	ИспользоватьРаспознавание = РаботаСФайламиВызовСервера.ПолучитьИспользоватьРаспознавание();
	ДоступноРаспознаваниеПоЗапросу = РаботаСФайламиВызовСервера.ДоступноРаспознаваниеПоЗапросу();
	Элементы.ГруппаРаспознавание.Видимость = ИспользоватьРаспознавание И ДоступноРаспознаваниеПоЗапросу;
	Если ИспользоватьРаспознавание = Ложь Тогда
		СтратегияРаспознавания = Перечисления.СтратегииРаспознаванияТекста.НеРаспознавать;
	Иначе
		
		ПрограммаРаспознавания = РаботаСФайламиВызовСервера.ПрограммаРаспознавания();
		
		ЯзыкРаспознавания = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"Распознавание", "ЯзыкРаспознавания");
		
		Если Не ЗначениеЗаполнено(ЯзыкРаспознавания) Тогда
			ЯзыкРаспознавания = РаботаСФайламиВызовСервера.ПолучитьЯзыкРаспознавания();
		КонецЕсли;
		
		ЯзыкиРаспознавания = РаботаСФайламиВызовСервера.ЯзыкиРаспознаванияПрограммы(ПрограммаРаспознавания);
		Если ЯзыкиРаспознавания.Найти(ЯзыкРаспознавания, "Language") = Неопределено Тогда
			ЯзыкРаспознавания = РаботаСФайламиВызовСервера.ЯзыкРаспознаванияПрограммыПоУмолчанию(ПрограммаРаспознавания);
		КонецЕсли;
		
		СтратегияРаспознавания = РаботаСФайламиВызовСервера.СтратегияРаспознаванияФайловВладельца(
			ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип("СправочникСсылка.ВнутренниеДокументы")));
		
		ПредставлениеНастроекРаспознавания =
			РаботаСФайламиВызовСервера.ПолучитьПредставлениеНастроекРаспознавания(
			СтратегияРаспознавания, ЯзыкРаспознавания);
		
		Команды.Настройка.Подсказка = ПредставлениеНастроекРаспознавания;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ВидДокумента) Тогда 
		ВидДокумента = 
			Делопроизводство.ПолучитьВидДокументаПоУмолчанию(Справочники.ВнутренниеДокументы.ПустаяСсылка());
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда 
		Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;
	
	Если Константы.ИспользоватьГрифыДоступа.Получить() Тогда
		ГрифДоступа = Константы.ГрифДоступаПоУмолчанию.Получить();
	КонецЕсли;	

	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьКатегорииДанных") Тогда
		Элементы.ГруппаКатегории.Видимость = Ложь;
	Иначе
		Если Параметры.Свойство("СписокКатегорий") Тогда
			Для каждого КатегорияВСписке Из Параметры.СписокКатегорий Цикл
				НоваяСтрока = СписокКатегорий.Добавить();
				НоваяСтрока.Значение = КатегорияВСписке;
				НоваяСтрока.ПолноеНаименование = РаботаСКатегориямиДанных.ПолучитьПолныйПутьКатегорииДанных(КатегорияВСписке);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Проект) Тогда
		Проект = РаботаСПроектами.ПолучитьПроектПоУмолчанию();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВидыВнутреннихДокументов") Тогда 
		ПроверяемыеРеквизиты.Добавить("ВидДокумента");
	КонецЕсли;	
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям")
		И ЗначениеЗаполнено(ВидДокумента) 
		И ПолучитьФункциональнуюОпцию("ВестиУчетПоОрганизациям",
			Новый Структура("ВидВнутреннегоДокумента", ВидДокумента)) Тогда
		ПроверяемыеРеквизиты.Добавить("Организация");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГрифыДоступа") Тогда 
		ПроверяемыеРеквизиты.Добавить("ГрифДоступа");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВопросыДеятельности") Тогда 
		ПроверяемыеРеквизиты.Добавить("ВопросДеятельности");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВидДокумента) Тогда
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДокумента, "ВестиУчетПоКонтрагентам") Тогда
			ПроверяемыеРеквизиты.Добавить("Контрагент");
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УтвердилНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Утвердил);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовилНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Подготовил);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	УстановитьВидимость()

КонецПроцедуры

&НаКлиенте
Процедура РегистрироватьДокументыПриИзменении(Элемент)
	
	Элементы.ДатаРегистрации.Доступность = РегистрироватьДокументы;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКатегорийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаРегистрацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = "ПроизвольнаяДата" Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПослеВводаДаты",
			ЭтотОбъект,
			Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение));

		ПоказатьВводДаты(ОписаниеОповещения, ДатаРегистрацииДокументов, Нстр("ru = 'Введите дату регистрации'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОригиналПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Расширение = ФайловыеФункцииКлиентСервер.ПолучитьРасширениеИмениФайла(ТекущиеДанные.ПолноеИмя);
	
	Если ТекущиеДанные.Оригинал Тогда 
		Если Не ДелопроизводствоКлиентСервер.ЭтоРасширениеСканКопии(Расширение) Тогда 
			ТекстВопроса = НСтр("ru = 'Выбранный файл, возможно, не является скан-копией. 
			|Вы действительно хотите отметить его как оригинал?'");
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ОригиналПриИзмененииПродолжение",
				ЭтотОбъект,
				Новый Структура("ТекущиеДанные", ТекущиеДанные));

			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет, 
				НСтр("ru = 'Отметка оригинала'"));
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОригиналПриИзмененииПродолжение(Результат, Параметры) Экспорт 

	Если Результат <> КодВозвратаДиалога.Да Тогда
		Параметры.ТекущиеДанные.Оригинал = Не Параметры.ТекущиеДанные.Оригинал;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыФайлы

&НаКлиенте
Процедура ФайлыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	#Если НЕ ВебКлиент Тогда
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
		ДиалогОткрытияФайла.МножественныйВыбор = Истина;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файлы'");
		
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
			Для Каждого ИмяФайла Из МассивФайлов Цикл
				ФайлПеренесенный = Новый Файл(ИмяФайла);
				
				НовыйЭлемент = Файлы.Добавить();
				НовыйЭлемент.ИмяФайла = ФайлПеренесенный.ИмяБезРасширения;
				НовыйЭлемент.ПутьФайла = ФайлПеренесенный.Путь;
				НовыйЭлемент.ПолноеИмя = ФайлПеренесенный.ПолноеИмя;
				НовыйЭлемент.ИндексКартинки = 
					ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(ФайлПеренесенный.Расширение);
				
				Если ДелопроизводствоКлиентСервер.ЭтоРасширениеСканКопии(ФайлПеренесенный.Расширение) Тогда 
					НовыйЭлемент.Оригинал = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		КоличествоФайлов = Файлы.Количество();
		Заголовок = СформироватьЗаголовок(КоличествоФайлов);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПослеУдаления(Элемент)
	
	КоличествоФайлов = Файлы.Количество();
	Заголовок = СформироватьЗаголовок(КоличествоФайлов);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкиРаспознавания(Команда)
	
	РаботаСФайламиКлиент.ВыбратьНастройкиРаспознавания(
		Новый Структура("СтратегияРаспознавания, ЯзыкРаспознавания", СтратегияРаспознавания, ЯзыкРаспознавания),
		ЭтаФорма,
		Новый ОписаниеОповещения("НастройкиРаспознаванияПродолжение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиРаспознаванияПродолжение(РезультатОткрытия, Параметры) Экспорт 

	Если ТипЗнч(РезультатОткрытия) = Тип("Структура") Тогда
		СтратегияРаспознавания = РезультатОткрытия.СтратегияРаспознавания;
		ЯзыкРаспознавания = РезультатОткрытия.ЯзыкРаспознавания;
		УстановитьПредставлениеНастроекРаспознавания(СтратегияРаспознавания, ЯзыкРаспознавания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеНастроекРаспознавания(СтратегияРаспознавания, ЯзыкРаспознавания)
	
	ПредставлениеНастроекРаспознавания = РаботаСФайламиВызовСервера.ПолучитьПредставлениеНастроекРаспознавания(
		СтратегияРаспознавания, ЯзыкРаспознавания);
	Команды.Настройка.Подсказка = ПредставлениеНастроекРаспознавания;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлы(Команда)
	
	#Если НЕ ВебКлиент Тогда
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
		ДиалогОткрытияФайла.МножественныйВыбор = Истина;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файлы'");
		
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			Файлы.Очистить();
			
			МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
			Для Каждого ИмяФайла Из МассивФайлов Цикл
				ФайлПеренесенный = Новый Файл(ИмяФайла);
				
				НовыйЭлемент = Файлы.Добавить();
				НовыйЭлемент.ИмяФайла = ФайлПеренесенный.ИмяБезРасширения;
				НовыйЭлемент.ПутьФайла = ФайлПеренесенный.Путь;
				НовыйЭлемент.ПолноеИмя = ФайлПеренесенный.ПолноеИмя;
				НовыйЭлемент.ИндексКартинки = ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(ФайлПеренесенный.Расширение);
				
				Если ДелопроизводствоКлиентСервер.ЭтоРасширениеСканКопии(ФайлПеренесенный.Расширение) Тогда 
					НовыйЭлемент.Оригинал = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		КоличествоФайлов = Файлы.Количество();
		Заголовок = СформироватьЗаголовок(КоличествоФайлов);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура Импорт(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;	
	
	ВыбранныеФайлы = Новый СписокЗначений;
	Для Каждого Строка Из Файлы Цикл
		ВыбранныеФайлы.Добавить(Строка.ПолноеИмя);
	КонецЦикла;	
	
	Рекурсивно = Ложь;
	КоличествоСуммарное = 0;
	ПсевдоФайловаяСистема = Новый Соответствие;
	РежимЗагрузки = Ложь;
	
	ДобавленныеФайлы = Новый Массив;
	ПараметрыРаспознавания = Новый Структура("СтратегияРаспознавания, ЯзыкРаспознавания", 
		СтратегияРаспознавания, ЯзыкРаспознавания);
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ОбработчикРезультата", Неопределено);
	ПараметрыВыполнения.Вставить("ПапкаДляДобавления", Неопределено);
	ПараметрыВыполнения.Вставить("ВыбранныеФайлы", ВыбранныеФайлы);
	ПараметрыВыполнения.Вставить("Комментарий", "");
	ПараметрыВыполнения.Вставить("ХранитьВерсии", Истина);
	ПараметрыВыполнения.Вставить("УдалятьФайлыПослеДобавления", УдалятьФайлыПослеДобавления);
	ПараметрыВыполнения.Вставить("Рекурсивно", Рекурсивно);
	ПараметрыВыполнения.Вставить("ИдентификаторФормы", УникальныйИдентификатор);
	ПараметрыВыполнения.Вставить("ПсевдоФайловаяСистема", ПсевдоФайловаяСистема);
	ПараметрыВыполнения.Вставить("ДобавленныеФайлы", ДобавленныеФайлы);
	ПараметрыВыполнения.Вставить("РежимЗагрузки", РежимЗагрузки);
	ПараметрыВыполнения.Вставить("Кодировка", Неопределено);
	ПараметрыВыполнения.Вставить("ПараметрыРаспознавания", ПараметрыРаспознавания);
	ПараметрыВыполнения.Вставить("СписокКатегорий", СписокКатегорий);
	
	Обработчик = Новый ОписаниеОповещения("ИмпортФайловПослеПроверкиРазмеров", ЭтотОбъект, ПараметрыВыполнения);
	РаботаСФайламиКлиент.ПроверитьПредельныйРазмерФайлов(Обработчик, ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
// Продолжение процедуры (см. выше).
Процедура ИмпортФайловПослеПроверкиРазмеров(Результат, ПараметрыВыполнения) Экспорт
	
	Состояние();
	
	Если Результат.Успех = Ложь Тогда
		РаботаСФайламиКлиент.ВернутьРезультат(ПараметрыВыполнения.ОбработчикРезультата, Неопределено);
		Возврат;
	КонецЕсли;
	
	ПараметрыВыполнения.Вставить("КоличествоСуммарное", Результат.КоличествоСуммарное);
	Если ПараметрыВыполнения.КоличествоСуммарное = 0 Тогда
		Если ПараметрыВыполнения.РежимЗагрузки Тогда
			РаботаСФайламиКлиент.ВернутьРезультат(ПараметрыВыполнения.ОбработчикРезультата, Неопределено);
		Иначе
			РаботаСФайламиКлиент.ВернутьРезультатПослеПоказаПредупреждения(ПараметрыВыполнения.ОбработчикРезультата, НСтр("ru = 'Нет файлов для добавления'"), Неопределено);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Счетчик = 0;
	Индикатор = 0;
	Путь = "";
	
	МассивИменФайловСОшибками = Новый Массив;
	МассивСтруктурВсехФайлов = Новый Массив;
	МассивВсехПапок = Новый Массив;
	ДобавленныеФайлы = Новый Массив;
	
	Комментарий = "";
	ХранитьВерсии = Истина;
	ИдентификаторФормы = УникальныйИдентификатор;
	
	МаксРазмерФайла = ФайловыеФункцииКлиентПовтИсп.ПолучитьОбщиеНастройкиРаботыСФайлами().МаксимальныйРазмерФайла;
	ЗапретЗагрузкиФайловПоРасширению = ФайловыеФункцииКлиентПовтИсп.ПолучитьОбщиеНастройкиРаботыСФайлами().ЗапретЗагрузкиФайловПоРасширению;
	СписокЗапрещенныхРасширений = ФайловыеФункцииКлиентПовтИсп.ПолучитьОбщиеНастройкиРаботыСФайлами().СписокЗапрещенныхРасширений;
	
	МассивФайлов = Новый Массив;
	Для Каждого ИмяФайла Из ПараметрыВыполнения.ВыбранныеФайлы Цикл
		Попытка
			ВыбранныйФайл = Новый Файл(ИмяФайла.Значение);
			МассивФайлов.Добавить(ВыбранныйФайл);
		Исключение
			Инфо = ИнформацияОбОшибке();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					   НСтр("ru = 'Описание=""%1""'"), Инфо.Описание ));
		КонецПопытки;
	КонецЦикла;
	
	Для Каждого ФайлМассива Из МассивФайлов Цикл
		
		Если Не ФайловыеФункцииКлиентСервер.ФайлМожноЗагружать(
			ФайлМассива, 
			МаксРазмерФайла, 
			ЗапретЗагрузкиФайловПоРасширению, 
			СписокЗапрещенныхРасширений, 
			МассивИменФайловСОшибками) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не РегистрироватьДокументы Или ДатаРегистрации = "ДатаИзмененияФайла" Тогда 
			ДатаРегистрацииДокументов = ФайлМассива.ПолучитьВремяИзменения();	
		ИначеЕсли ДатаРегистрации = "ТекущаяДата" Тогда 
			ДатаРегистрацииДокументов = ТекущаяДата();
		ИначеЕсли ДатаРегистрации = "ДатаСозданияФайла" Тогда 
			ДатаРегистрацииДокументов = ФайлМассива.ПолучитьУниверсальноеВремяИзменения();
		КонецЕсли;

		ВладелецФайла = СоздатьВнутреннийДокумент(ФайлМассива.ИмяБезРасширения, ДатаРегистрацииДокументов);
		
		СозданныйФайлСсылка = РаботаСФайламиКлиент.СоздатьДокументНаОсновеФайла(
			ФайлМассива.ПолноеИмя,
			ВладелецФайла,
			ЭтаФорма, 
			Истина, //НеОткрыватьКарточкуПослеСозданияИзФайла,
			Неопределено, // ИмяСоздаваемогоФайла
			ПараметрыВыполнения.ПараметрыРаспознавания,
			ПараметрыВыполнения.СписокКатегорий);
			
		Запись = Новый Структура;
		Запись.Вставить("ИмяФайла", ФайлМассива.ПолноеИмя);
		Запись.Вставить("Файл", СозданныйФайлСсылка);
		МассивСтруктурВсехФайлов.Добавить(Запись);
			
		Если ВестиУчетСканКопийОригиналовДокументов Тогда 
			НайденнаяСтрока = Неопределено;
			Для Каждого Строка Из Файлы	Цикл
				Если Строка.ПолноеИмя = ФайлМассива.ПолноеИмя Тогда 
					НайденнаяСтрока = Строка;
					Прервать;
				КонецЕсли;	
			КонецЦикла;	
			Если НайденнаяСтрока <> Неопределено И НайденнаяСтрока.Оригинал Тогда 
				Для Каждого ДобавленныйФайл Из МассивСтруктурВсехФайлов Цикл
					Если ДобавленныйФайл.ИмяФайла = ФайлМассива.ПолноеИмя Тогда 
						Делопроизводство.СохранитьСведенияОбОригиналеФайла(ДобавленныйФайл.Файл, ВладелецФайла);
						Прервать;
					КонецЕсли;	
				КонецЦикла;	
			КонецЕсли;	
		КонецЕсли;		
			
	КонецЦикла;	
	
	
	Если МассивСтруктурВсехФайлов.Количество() > 1 Тогда
		Состояние();
		
		ТекстСостояния = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Импорт файлов завершен. Импортировано %1 файлов'"), 
			Строка(МассивСтруктурВсехФайлов.Количество()) );
			
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Импорт файлов:'"),
			,
			ТекстСостояния,
			БиблиотекаКартинок.Информация32);
	Иначе
		Состояние();
	КонецЕсли;
			
	Если УдалятьФайлыПослеДобавления = Истина Тогда
		РежимЗагрузки = Ложь;
		ФайловыеФункцииКлиентСервер.УдалитьФайлыПослеДобавления(МассивСтруктурВсехФайлов, МассивВсехПапок, РежимЗагрузки);
	КонецЕсли;
	
	// Вывод сообщений об ошибках
	Если МассивИменФайловСОшибками.Количество() <> 0 Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("МассивИменФайловСОшибками", МассивИменФайловСОшибками);
		Если РежимЗагрузки Тогда
			ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Отчет о загрузке файлов'"));
		КонецЕсли;
		
		ОткрытьФорму("Справочник.Файлы.Форма.ФормаОтчета", ПараметрыФормы);
	КонецЕсли;
	
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ДанныеВнутреннихДокументов"));
	Оповестить("ИмпортФайловВСписокВнутреннихДокументовЗавершен");
	Закрыть();	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКатегории(Команда)
	
	РаботаСКатегориямиДанныхКлиент.ОткрытьФормуПодбораКатегорийДляСпискаКатегорий(СписокКатегорий);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВводаДаты(Дата, Параметры) Экспорт
	
	Если НЕ Дата = Неопределено Тогда
		ЗначениеСписка = Элементы.ДатаРегистрации.СписокВыбора.НайтиПоЗначению(Параметры.ВыбранноеЗначение);
		ЗначениеСписка.Представление = Формат(Дата, "ДФ='dd.MM.yyyy ЧЧ:мм'");
		ДатаРегистрацииДокументов = Дата;
	Иначе 
		ДатаРегистрации = "ТекущаяДата";
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция СоздатьВнутреннийДокумент(Заголовок, ДатаРегистрации)
	
	ДокументОбъект = Справочники.ВнутренниеДокументы.СоздатьЭлемент();
	ДокументОбъект.Заголовок = Заголовок;
	ДокументОбъект.Папка = Папка;
	ДокументОбъект.ВидДокумента = ВидДокумента;
	ДокументОбъект.ГрифДоступа = ГрифДоступа;
	Если ЗначениеЗаполнено(ДокументОбъект.ВидДокумента) 
		И ПолучитьФункциональнуюОпцию("ВестиУчетПоОрганизациям",
			Новый Структура("ВидВнутреннегоДокумента", ДокументОбъект.ВидДокумента)) Тогда
		ДокументОбъект.Организация = Организация;
	КонецЕсли;	
	ДокументОбъект.ВопросДеятельности = ВопросДеятельности;
	ДокументОбъект.Подготовил = Подготовил;
	ДокументОбъект.Утвердил = Утвердил;
	ДокументОбъект.Контрагент = Контрагент;
	ДокументОбъект.КонтактноеЛицо = КонтактноеЛицо;
	ДокументОбъект.ПодписалОтКонтрагента = ПодписалОтКонтрагента;
	ДокументОбъект.ДатаСоздания = ТекущаяДатаСеанса();
	ДокументОбъект.Проект = Проект;
	
	// Заполнение валюты
	Если ЗначениеЗаполнено(ДокументОбъект.ВидДокумента) 
		И ПолучитьФункциональнуюОпцию("ИспользоватьСуммуВоВнутренних",
		Новый Структура("ВидВнутреннегоДокумента", ДокументОбъект.ВидДокумента)) Тогда
		ДокументОбъект.Валюта = Делопроизводство.ПолучитьВалютуПоУмолчанию();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументОбъект.Контрагент) Тогда 
		Строка = ДокументОбъект.Контрагенты.Добавить();
		Строка.Контрагент = ДокументОбъект.Контрагент;
		Строка.КонтактноеЛицо = ДокументОбъект.КонтактноеЛицо;
		Строка.ПодписалОтКонтрагента = ДокументОбъект.ПодписалОтКонтрагента;		
	КонецЕсли;	

	Если РегистрироватьДокументы
		И Не ПравоРегистрировать
		И Не ДокументооборотПраваДоступа.ЕстьПравоРегистрации(ДокументОбъект) Тогда
		ВызватьИсключение НСтр("ru = 'У вас нет прав на регистрацию документов с указанными параметрами.'");
	Иначе 
		ПравоРегистрировать = Истина;
	КонецЕсли;
	
	ДокументОбъект.Записать();
	
	Если РегистрироватьДокументы Тогда 
		
		Нумератор = Нумерация.ПолучитьНумераторДокумента(ДокументОбъект); 
		Если ЗначениеЗаполнено(Нумератор) Тогда // автоматическая нумерация
			
			ДокументОбъект.ДатаРегистрации = ДатаРегистрации;
			
			// сформируем текущий номер
			СтруктураПараметров = НумерацияКлиентСервер.ПолучитьПараметрыНумерации(ДокументОбъект);
			Нумерация.СформироватьЧисловойНомерДокумента(СтруктураПараметров, ДокументОбъект.ЧисловойНомер);
			
			ОписанияОшибок = Новый СписокЗначений;
			СтруктураПараметров = НумерацияКлиентСервер.ПолучитьПараметрыНумерации(ДокументОбъект);
			Нумерация.СформироватьСтроковыйНомерДокумента(СтруктураПараметров, ДокументОбъект.РегистрационныйНомер, ОписанияОшибок);
			
			ДокументОбъект.Зарегистрировал = ПользователиКлиентСервер.ТекущийПользователь();
			ДокументОбъект.Записать();
			
			Делопроизводство.ЗаписатьСостояниеДокумента(
				ДокументОбъект.Ссылка, 
				ДатаРегистрации, 
				Перечисления.СостоянияДокументов.Зарегистрирован, 
				ПользователиКлиентСервер.ТекущийПользователь());
		КонецЕсли;	
		
	Иначе	
		Если ЗначениеЗаполнено(Утвердил) Тогда 
			Делопроизводство.ЗаписатьСостояниеДокумента(
				ДокументОбъект.Ссылка, 
				ДатаРегистрации, 
				Перечисления.СостоянияДокументов.Утвержден, 
				ПользователиКлиентСервер.ТекущийПользователь());
		Иначе		
			Делопроизводство.ЗаписатьСостояниеДокумента(
				ДокументОбъект.Ссылка, 
				ДатаРегистрации, 
				Перечисления.СостоянияДокументов.Проект, 
				ПользователиКлиентСервер.ТекущийПользователь());
		КонецЕсли;		
	КонецЕсли;		
	
	Возврат ДокументОбъект.Ссылка;		
	
КонецФункции

&НаКлиенте
Процедура УстановитьВидимость()
	
	Если ЗначениеЗаполнено(ВидДокумента) Тогда
		Если ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(ВидДокумента, 
			"ВестиУчетПоКонтрагентам") Тогда
			Элементы.Контрагент.Видимость = Истина;
			Элементы.ПодписалОтКонтрагента.Видимость = Истина;
			Элементы.КонтактноеЛицо.Видимость = Истина;
		Иначе
			Элементы.Контрагент.Видимость = Ложь;
			Элементы.ПодписалОтКонтрагента.Видимость = Ложь;
			Элементы.КонтактноеЛицо.Видимость = Ложь;
		КонецЕсли;	
		Если ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(ВидДокумента, 
			"ВестиУчетПоОрганизациям") Тогда
			Элементы.Организация.Видимость = Истина;
		Иначе
			Элементы.Организация.Видимость = Ложь;
		КонецЕсли;	
	Иначе
		Элементы.Организация.Видимость = Ложь;	
		Элементы.Контрагент.Видимость = Ложь;	
		Элементы.ПодписалОтКонтрагента.Видимость = Ложь;
		Элементы.КонтактноеЛицо.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьЗаголовок(ЧислоФайлов)
	
	ЗаголовокФормы = "";
	
	Если ЧислоФайлов = 0 Тогда
		ЗаголовокФормы = НСтр("ru='Загрузка файлов'");
	Иначе
		ЗаголовокФормы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Загрузка файлов (%1)'"), Строка(ЧислоФайлов));
	КонецЕсли;	
		
	Возврат ЗаголовокФормы;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервереРедакцииКонфигурации()	
	
	Элементы.Организация.Заголовок = РедакцииКонфигурацииКлиентСервер.Организация();
		
КонецПроцедуры

#КонецОбласти
