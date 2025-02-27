﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьЧатБота = РаботаСЧатБотом.ЧатБотИспользуется();
	Элементы.ГруппаЧатБотНадпись.Видимость = Не ИспользоватьЧатБота;
	
	// Заполнение уведомлений и настроек уведомлений
	ПолучитьНастройки();
	
	// Заполнение адресов для уведомлений
	ПолучитьСпособыУведомления();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Настройки были изменены. Сохранить изменения?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СохранитьНастройкиНаКлиенте();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Пользователь"
		Или ИмяСобытия = "ИзмененыНастройкиУведомлений" Тогда
		ПолучитьСпособыУведомленияНаКлиенте();
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменилосьИспользованиеЧатБота" Тогда
	
		ИспользоватьЧатБота = Параметр;
		ОбновитьЭлементыФормы();
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РазмерSMSПриИзменении(Элемент)
	
	Если РазмерSMS = 0 Тогда
		РазмерSMS = РаботаСУведомлениямиКлиентСервер.РазмерSMS(
			1,
			ИспользоватьТранслитерациюSMS);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазмерSMSРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	КоличествоЧастей = РаботаСУведомлениямиКлиентСервер.КоличествоЧастейSMS(
		РазмерSMS,
		ИспользоватьТранслитерациюSMS);
	РазмерSMS = РаботаСУведомлениямиКлиентСервер.РазмерSMS(
		КоличествоЧастей + Направление,
		ИспользоватьТранслитерациюSMS);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьТранслитерациюSMSПриИзменении(Элемент)
	
	КоличествоЧастей = РаботаСУведомлениямиКлиентСервер.КоличествоЧастейSMS(
		РазмерSMS,
		Не ИспользоватьТранслитерациюSMS);
	РазмерSMS = РаботаСУведомлениямиКлиентСервер.РазмерSMS(
		КоличествоЧастей,
		ИспользоватьТранслитерациюSMS);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодпискиУведомлений

&НаКлиенте
Процедура ПодпискиУведомленийПриИзменении(Элемент)
	
	ОбновитьПодпискаАктивна(
		ПодпискиУведомлений,
		СрокиУведомлений,
		ЧастотыУведомлений,
		ДополнительныеНастройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСпособыУведомления

&НаКлиенте
Процедура СпособыУведомленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Пользователь = ПредопределенноеЗначение("Справочник.РабочиеГруппы.ВсеПользователи") Тогда
		ПараметрыФормы = Новый Структура;
		ОткрытьФорму(
			"РегистрСведений.СпособыУведомленияПользователей.Форма.СпособыУведомленияВсехПользователей",
			ПараметрыФормы,
			ЭтаФорма);
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.ВидКонтактнойИнформации) Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.Пользователь);
		ПараметрыФормы.Вставить("ВидКонтактнойИнформации", ТекущиеДанные.ВидКонтактнойИнформации);
		ПараметрыФормы.Вставить("ПредставлениеКонтактнойИнформации", ТекущиеДанные.ДанныеСпособа);
		ОткрытьФорму("Справочник.Пользователи.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Пользователь", ТекущиеДанные.Пользователь);
		ПараметрыФормы.Вставить("ОтобразитьСпособыДоставки", Истина);
		ПараметрыФормы.Вставить("СпособДоставки", ТекущиеДанные.ДанныеСпособа);
		ОткрытьФорму("ОбщаяФорма.ПодпискиПользователя", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	СохранитьНастройкиНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОчиститьЗавершение", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Очистить настройки уведомлений всех пользователей?'");
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УведомленияSMS(Команда)
	
	ОткрытьФорму("Документ.УведомлениеПоSMS.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьНастройки()
	
	// Уведомления
	ПодпискиУведомлений.Очистить();
	ДоступныеПодписки = РегистрыСведений.НастройкиУведомлений.ДоступныеПодписки();
	Для Каждого Подписка Из ДоступныеПодписки Цикл
		НоваяСтрока = ПодпискиУведомлений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Подписка);
		НоваяСтрока.ПоПочте = РегистрыСведений.НастройкиУведомлений.ПолучитьПодпискуПоУмолчанию(
			Подписка.ВидСобытия,
			Перечисления.СпособыУведомления.ПоПочте);
		НоваяСтрока.Окном = РегистрыСведений.НастройкиУведомлений.ПолучитьПодпискуПоУмолчанию(
			Подписка.ВидСобытия,
			Перечисления.СпособыУведомления.Окном);
		НоваяСтрока.ПоSMS = РегистрыСведений.НастройкиУведомлений.ПолучитьПодпискуПоУмолчанию(
			Подписка.ВидСобытия,
			Перечисления.СпособыУведомления.ПоSMS);
		Если ПолучитьФункциональнуюОпцию("ИспользоватьPushУведомления") Тогда
			НоваяСтрока.ПоPush = РегистрыСведений.НастройкиУведомлений.ПолучитьПодпискуПоУмолчанию(
				Подписка.ВидСобытия,
				Перечисления.СпособыУведомления.ПоPush);
		КонецЕсли;
			
		НоваяСтрока.Чат = РегистрыСведений.НастройкиУведомлений.ПолучитьПодпискуПоУмолчанию(
			Подписка.ВидСобытия,
			Перечисления.СпособыУведомления.Чат);
			
	КонецЦикла;
	Элементы.ПодпискиУведомлений.Видимость = (ПодпискиУведомлений.Количество() <> 0);
	
	// Частоты и сроки уведомлений - Сроки уведомлений
	СрокиУведомлений.Очистить();
	ДоступныеСроки = РегистрыСведений.НастройкиУведомлений.ДоступныеСроки();
	Для Каждого НастройкаСрока Из ДоступныеСроки Цикл
		НоваяСтрока = СрокиУведомлений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, НастройкаСрока);
		НоваяСтрока.Срок = РегистрыСведений.НастройкиУведомлений.ПолучитьСрокПоУмолчанию(
			НастройкаСрока.ВидСобытия);
	КонецЦикла;
	Элементы.СрокиУведомлений.Видимость = (СрокиУведомлений.Количество() <> 0);
	
	// Частоты и сроки уведомлений - Частоты уведомлений
	ЧастотыУведомлений.Очистить();
	ДоступныеЧастоты = РегистрыСведений.НастройкиУведомлений.ДоступныеЧастоты();
	Для Каждого НастройкаЧастоты Из ДоступныеЧастоты Цикл
		НоваяСтрока = ЧастотыУведомлений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, НастройкаЧастоты);
		НоваяСтрока.Частота = РегистрыСведений.НастройкиУведомлений.ПолучитьЧастотуПоУмолчанию(
			НастройкаЧастоты.ВидСобытия);
	КонецЦикла;
	Элементы.ЧастотыУведомлений.Видимость = (ЧастотыУведомлений.Количество() <> 0);
	
	// Способы уведомлений
	ПолучитьСпособыУведомления();
	
	// Дополнительные настройки
	ДополнительныеНастройки.Очистить();
	ДоступныеДополнительныеНастройки = РегистрыСведений.НастройкиУведомлений.ДоступныеДополнительныеНастройки();
	Для Каждого ДополнительнаяНастройка Из ДоступныеДополнительныеНастройки Цикл
		НоваяСтрока = ДополнительныеНастройки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДополнительнаяНастройка);
		НоваяСтрока.Значение = РегистрыСведений.НастройкиУведомлений.ПолучитьДополнительнуюНастройкуПоУмолчанию(
			ДополнительнаяНастройка.Настройка);
	КонецЦикла;
	Элементы.ДополнительныеНастройки.Видимость = (ДополнительныеНастройки.Количество() <> 0);
	
	// Дополнительные настройки - Разрешить пользователям изменять настройки уведомлений
	РазрешитьИзменятьНастройкиУведомлений = РегистрыСведений.НастройкиУведомлений.РазрешеноИзменятьНастройки();
	
	// Дополнительные настройки - УведомленияОкномПоказыватьВЦентреОповещений
	УведомленияОкномПоказыватьВЦентреОповещений = Константы.УведомленияОкномПоказыватьВЦентреОповещений.Получить();
	
	// Дополнительные настройки - Адрес публикации на веб-сервере
	АдресПубликацииНаВебСервере = Константы.АдресПубликацииНаВебСервере.Получить();
	
	// Отправка SMS - Размер сообщения
	РазмерSMS = Константы.РазмерSMS.Получить();
	
	// Отправка SMS - Использовать транслитерацию
	ИспользоватьТранслитерациюSMS = Константы.ИспользоватьТранслитерациюSMS.Получить();
	
	// Отправка SMS - Для пользователя (в день)
	ОграничениеКоличестваВДеньSMS = Константы.ОграничениеКоличестваВДеньSMS.Получить();
	
	// Отправка SMS - Для пользователя (в месяц)
	ОграничениеКоличестваВМесяцSMS = Константы.ОграничениеКоличестваВМесяцSMS.Получить();
	
	// Отправка SMS - Всего (в день)
	ОграничениеКоличестваВсегоВДеньSMS = Константы.ОграничениеКоличестваВсегоВДеньSMS.Получить();
	
	// Отправка SMS - Всего (в месяц)
	ОграничениеКоличестваВсегоВМесяцSMS = Константы.ОграничениеКоличестваВсегоВДеньSMS.Получить();
	
	// Обновление данных об активности подписок.
	ОбновитьПодпискаАктивна(
		ПодпискиУведомлений,
		СрокиУведомлений,
		ЧастотыУведомлений,
		ДополнительныеНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиНаКлиенте()
	
	// Сохранение настроек и закрытие формы.
	СохранитьНастройки();
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	НачатьТранзакцию();
	Попытка
		
		// Уведомления
		Для Каждого Подписка Из ПодпискиУведомлений Цикл
			РегистрыСведений.НастройкиУведомлений.УстановитьПодпискуПоУмолчанию(
				Подписка.ВидСобытия,
				Перечисления.СпособыУведомления.ПоПочте,
				Подписка.ПоПочте);
			РегистрыСведений.НастройкиУведомлений.УстановитьПодпискуПоУмолчанию(
				Подписка.ВидСобытия,
				Перечисления.СпособыУведомления.Окном,
				Подписка.Окном);
			РегистрыСведений.НастройкиУведомлений.УстановитьПодпискуПоУмолчанию(
				Подписка.ВидСобытия,
				Перечисления.СпособыУведомления.ПоSMS,
				Подписка.ПоSMS);
			Если ПолучитьФункциональнуюОпцию("ИспользоватьPushУведомления") Тогда
				РегистрыСведений.НастройкиУведомлений.УстановитьПодпискуПоУмолчанию(
					Подписка.ВидСобытия,
					Перечисления.СпособыУведомления.ПоPush,
					Подписка.ПоPush);
			КонецЕсли;
			РегистрыСведений.НастройкиУведомлений.УстановитьПодпискуПоУмолчанию(
				Подписка.ВидСобытия,
				Перечисления.СпособыУведомления.Чат,
				Подписка.Чат);
		КонецЦикла;
		
		// Частоты и сроки уведомлений - Сроки уведомлений
		Для Каждого НастройкаСрока Из СрокиУведомлений Цикл
			РегистрыСведений.НастройкиУведомлений.УстановитьСрокПоУмолчанию(
				НастройкаСрока.ВидСобытия,
				НастройкаСрока.Срок);
		КонецЦикла;
		
		// Частоты и сроки уведомлений - Частоты уведомлений
		Для Каждого НастройкаЧастоты Из ЧастотыУведомлений Цикл
			РегистрыСведений.НастройкиУведомлений.УстановитьЧастотуПоУмолчанию(
				НастройкаЧастоты.ВидСобытия,
				НастройкаЧастоты.Частота);
		КонецЦикла;
		
		// Дополнительные настройки
		Для Каждого ДополнительнаяНастройка Из ДополнительныеНастройки Цикл
			РегистрыСведений.НастройкиУведомлений.УстановитьДополнительнуюНастройкуПоУмолчанию(
				ДополнительнаяНастройка.Настройка,
				ДополнительнаяНастройка.Значение);
		КонецЦикла;
		
		// Дополнительные настройки - Разрешить пользователям изменять настройки уведомлений
		Константы.РазрешитьИзменятьНастройкиУведомлений.Установить(РазрешитьИзменятьНастройкиУведомлений);
		
		// Дополнительные настройки - УведомленияОкномПоказыватьВЦентреОповещений
		Константы.УведомленияОкномПоказыватьВЦентреОповещений.Установить(УведомленияОкномПоказыватьВЦентреОповещений);
		
		// Дополнительные настройки - Адрес публикации на веб-сервере
		Константы.АдресПубликацииНаВебСервере.Установить(АдресПубликацииНаВебСервере);
		
		// Отправка SMS - Размер сообщения
		Константы.РазмерSMS.Установить(РазмерSMS);
		
		// Отправка SMS - Использовать транслитерацию
		Константы.ИспользоватьТранслитерациюSMS.Установить(ИспользоватьТранслитерациюSMS);
		
		// Отправка SMS - Для пользователя (в день)
		Константы.ОграничениеКоличестваВДеньSMS.Установить(ОграничениеКоличестваВДеньSMS);
		
		// Отправка SMS - Для пользователя (в месяц)
		Константы.ОграничениеКоличестваВМесяцSMS.Установить(ОграничениеКоличестваВМесяцSMS);
		
		// Отправка SMS - Всего (в день)
		Константы.ОграничениеКоличестваВсегоВДеньSMS.Установить(ОграничениеКоличестваВсегоВДеньSMS);
		
		// Отправка SMS - Всего (в месяц)
		Константы.ОграничениеКоличестваВсегоВМесяцSMS.Установить(ОграничениеКоличестваВсегоВМесяцSMS);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСпособыУведомления()
	
	Дерево = РеквизитФормыВЗначение("СпособыУведомления");
	Дерево.Строки.Очистить();
	
	ДанныеСпособовУведомлений = РегистрыСведений.СпособыУведомленияПользователей.ПолучитьВсеСпособыУведомления();
	ПараметрыОтбора = Новый Структура("Пользователь");
	
	// Группа "Все пользователи"
	СтрокаВсеПользователи = Дерево.Строки.Добавить();
	СтрокаВсеПользователи.Пользователь = Справочники.РабочиеГруппы.ВсеПользователи;
	СтрокаВсеПользователи.Представление = Справочники.РабочиеГруппы.ВсеПользователи;
	СтрокаВсеПользователи.ЭтоГруппа = Истина;
	ПараметрыОтбора.Пользователь = Справочники.РабочиеГруппы.ВсеПользователи;
	ДанныеСпособовУведомленийВсехПользователей = ДанныеСпособовУведомлений.НайтиСтроки(ПараметрыОтбора);
	Для Каждого ДанныеСпособаУведомления Из ДанныеСпособовУведомленийВсехПользователей Цикл
		СтрокаСпособаУведомления = СтрокаВсеПользователи.Строки.Добавить();
		СтрокаСпособаУведомления.Пользователь = Справочники.РабочиеГруппы.ВсеПользователи;
		СтрокаСпособаУведомления.ЭтоГруппа = Ложь;
		ЗаполнитьЗначенияСвойств(СтрокаСпособаУведомления, ДанныеСпособаУведомления, , "Пользователь");
	КонецЦикла;
	
	// Пользователи
	ВсеПользователи = РаботаСПользователями.ПолучитьВсехПользователей();
	Сортировка = Новый СписокЗначений;
	Сортировка.ЗагрузитьЗначения(ВсеПользователи);
	Сортировка.СортироватьПоЗначению();
	ВсеПользователи = Сортировка.ВыгрузитьЗначения();
	Для Каждого Пользователь Из ВсеПользователи Цикл
		СтрокаПользователя = Дерево.Строки.Добавить();
		СтрокаПользователя.Пользователь = Пользователь;
		СтрокаПользователя.Представление = Пользователь;
		СтрокаПользователя.ЭтоГруппа = Истина;
		ПараметрыОтбора.Пользователь = Пользователь;
		ДанныеСпособовУведомленийПользователя = ДанныеСпособовУведомлений.НайтиСтроки(ПараметрыОтбора);
		Для Каждого ДанныеСпособаУведомления Из ДанныеСпособовУведомленийПользователя Цикл
			СтрокаСпособаУведомления = СтрокаПользователя.Строки.Добавить();
			СтрокаСпособаУведомления.ЭтоГруппа = Ложь;
			ЗаполнитьЗначенияСвойств(СтрокаСпособаУведомления, ДанныеСпособаУведомления);
		КонецЦикла;
	КонецЦикла;
	
	// Индексы картинок
	Для Каждого СтрокаПользователя Из Дерево.Строки Цикл
		Если ТипЗнч(СтрокаПользователя.Пользователь) = Тип("СправочникСсылка.РабочиеГруппы") Тогда
			СтрокаПользователя.ИндексКартинки = 0;
		ИначеЕсли ТипЗнч(СтрокаПользователя.Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
			СтрокаПользователя.ИндексКартинки = 1;
		КонецЕсли;
		Для Каждого СтрокаСпособаУведомления Из СтрокаПользователя.Строки Цикл
			Если СтрокаСпособаУведомления.СпособУведомления = Перечисления.СпособыУведомления.ПоПочте Тогда
				СтрокаСпособаУведомления.ИндексКартинки = 2;
			ИначеЕсли СтрокаСпособаУведомления.СпособУведомления = Перечисления.СпособыУведомления.ПоSMS Тогда
				СтрокаСпособаУведомления.ИндексКартинки = 4;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаСпособаУведомления.ВидКонтактнойИнформации) Тогда
				СтрокаСпособаУведомления.ИндексКартинки = СтрокаСпособаУведомления.ИндексКартинки + 1;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "СпособыУведомления");
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСпособыУведомленияНаКлиенте()
	
	СвернутыеСтроки = Новый Массив;
	Для Каждого Строка Из СпособыУведомления.ПолучитьЭлементы() Цикл
		Если Не Элементы.СпособыУведомления.Развернут(Строка.ПолучитьИдентификатор()) Тогда
			СвернутыеСтроки.Добавить(Строка.Пользователь);
		КонецЕсли;
	КонецЦикла;
	ТекущийПользователь = Неопределено;
	ТекущиеДанные = Элементы.СпособыУведомления.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущийПользователь = ТекущиеДанные.Пользователь;
	КонецЕсли;
	
	ПолучитьСпособыУведомления();
	
	Для Каждого Строка Из СпособыУведомления.ПолучитьЭлементы() Цикл
		Если СвернутыеСтроки.Найти(Строка.Пользователь) <> Неопределено Тогда
			Элементы.СпособыУведомления.Свернуть(Строка.ПолучитьИдентификатор());
		Иначе
			Элементы.СпособыУведомления.Развернуть(Строка.ПолучитьИдентификатор());
		КонецЕсли;
		Если Строка.Пользователь = ТекущийПользователь Тогда
			Элементы.СпособыУведомления.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПодпискаАктивна(
	ПодпискиУведомлений,
	СрокиУведомлений,
	ЧастотыУведомлений,
	ДополнительныеНастройки)
	
	ПараметрыОтбора = Новый Структура("ОсновноеСобытие");
	
	Для Каждого НастройкаСрока Из СрокиУведомлений Цикл
		ПараметрыОтбора.ОсновноеСобытие = НастройкаСрока.ВидСобытия;
		НайденныеСтроки = ПодпискиУведомлений.НайтиСтроки(ПараметрыОтбора);
		ПодпискаАктивна = Ложь;
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ПодпискаАктивна = ПодпискаАктивна
				Или НайденнаяСтрока.ПоПочте
				Или НайденнаяСтрока.ПоSMS
				Или НайденнаяСтрока.Окном
				Или НайденнаяСтрока.ПоPush
				Или НайденнаяСтрока.Чат;
		КонецЦикла;
		НастройкаСрока.ПодпискаАктивна = ПодпискаАктивна;
	КонецЦикла;
	
	Для Каждого НастройкаЧастоты Из ЧастотыУведомлений Цикл
		ПараметрыОтбора.ОсновноеСобытие = НастройкаЧастоты.ВидСобытия;
		НайденныеСтроки = ПодпискиУведомлений.НайтиСтроки(ПараметрыОтбора);
		ПодпискаАктивна = Ложь;
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ПодпискаАктивна = ПодпискаАктивна
				Или НайденнаяСтрока.ПоПочте
				Или НайденнаяСтрока.ПоSMS
				Или НайденнаяСтрока.Окном
				Или НайденнаяСтрока.ПоPush
				Или НайденнаяСтрока.Чат;
		КонецЦикла;
		НастройкаЧастоты.ПодпискаАктивна = ПодпискаАктивна;
	КонецЦикла;
	
	Для Каждого ДополнительнаяНастройка Из ДополнительныеНастройки Цикл
		ПараметрыОтбора.ОсновноеСобытие = ДополнительнаяНастройка.ВидСобытия;
		НайденныеСтроки = ПодпискиУведомлений.НайтиСтроки(ПараметрыОтбора);
		ПодпискаАктивна = Ложь;
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ПодпискаАктивна = ПодпискаАктивна
				Или НайденнаяСтрока.ПоПочте
				Или НайденнаяСтрока.ПоSMS
				Или НайденнаяСтрока.Окном
				Или НайденнаяСтрока.ПоPush
				Или НайденнаяСтрока.Чат;
		КонецЦикла;
		ДополнительнаяНастройка.ПодпискаАктивна = ПодпискаАктивна;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьНаСервере()
	
	РегистрыСведений.НастройкиУведомлений.УдалитьВсеНастройкиПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтправкуSMS(Команда)
	
	ОткрытьФорму("ОбщаяФорма.НастройкаОтправкиSMS");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЧатБота(Команда)
	
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.НастройкиЧатБота");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЭлементыФормы() 
	
	Элементы.ПодпискиУведомленийЧат.Видимость = ИспользоватьЧатБота;
	
КонецПроцедуры

#КонецОбласти