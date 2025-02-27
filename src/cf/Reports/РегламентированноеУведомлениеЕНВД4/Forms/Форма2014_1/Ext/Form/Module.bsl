﻿&НаКлиенте
Перем UID_Пустой;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ЗначениеКопирования = Неопределено;
	ПараметрыЗаполнения = Неопределено;
	Параметры.Свойство("ЗначениеКопирования", ЗначениеКопирования);
	Параметры.Свойство("ПараметрыЗаполнения", ПараметрыЗаполнения);
	
	Если НЕ (Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка)) Тогда 
		Объект.Организация = Параметры.Организация;
		Если Параметры.Свойство("НалоговыйОрган") И ЗначениеЗаполнено(Параметры.НалоговыйОрган) Тогда 
			Объект.РегистрацияВИФНС = Параметры.НалоговыйОрган;
		Иначе
			Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		КонецЕсли;
		Параметры.Свойство("КодПричины", КодПричины)
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда 
		ОбщегоНазначения.СообщитьПользователю("Сообщение по форме ЕНВД-4 можно создавать только для индивидуальных предпринимателей");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ДатаПодписи = ТекущаяДатаСеанса();
		ЭтотОбъект.Заголовок = ЭтотОбъект.Заголовок + " (создание)";
	КонецЕсли;
	
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭтаФорма.ИмяФормы, ".");
	Объект.ИмяФормы = Разложение[3];
	Объект.ИмяОтчета = Разложение[1];
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗагрузитьДанныеЕНВД(ЭтотОбъект, ЗначениеКопирования);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗагрузитьМакетыУведомления(ЭтотОбъект, Объект.ИмяОтчета, "ПараметрыФорма2014_1");
	Документы.УведомлениеОСпецрежимахНалогообложения.СформироватьДеревоЛистовЕНВДУведомления(ЭтотОбъект);
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	СтруктураРеквизитов = РегламентированнаяОтчетность.СформироватьСтруктуруОбязательныхРеквизитовУведомления();
	мСтруктураВариантыЗаполнения = Новый Структура;
	РегламентированнаяОтчетность.СформироватьСоставПоказателей(ЭтаФорма, "СоставПоказателей2014_1");
	РегламентированнаяОтчетность.ПолучитьСведенияОПоказателяхУведомления(ЭтаФорма);
	Элементы.ФормаЗаполнить.Видимость = СтруктураРеквизитов.ОтображатьКнопкуЗаполнить;
	
	РегламентированнаяОтчетность.ДобавитьКнопкуПрисоединенныеФайлы(ЭтаФорма);
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	Если Параметры.Свойство("СформироватьФормуОтчетаАвтоматически") Тогда 
		ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка, , УникальныйИдентификатор);
	КонецЕсли;
	
	Если НЕ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.СобытиеНаступило("Отпр.ЕНВД-4") Тогда
		Элементы.ОтправитьВКонтролирующийОрган.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.Разделы.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	UID_Пустой = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьТитульныйЛист(НовыйЛист) Экспорт 
	
	НовыйЛист.UID = Новый УникальныйИдентификатор;
	НовыйЛист.ДАТА_ПОДПИСИ = ТекущаяДатаСеанса(); 
	Объект.ДатаПодписи = НовыйЛист.ДАТА_ПОДПИСИ;
	
	СтрокаСведений = "ИННФЛ,ТелДом,ОГРН,ФИО,ФамилияИП,ИмяИП,ОтчествоИП";
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
	
	НовыйЛист.Фамилия_ИП = СведенияОбОрганизации.ФамилияИП;
	НовыйЛист.Имя_ИП = СведенияОбОрганизации.ИмяИП;
	НовыйЛист.Отчество_ИП = СведенияОбОрганизации.ОтчествоИП;
	НовыйЛист.П_ОГРНИП = СведенияОбОрганизации.ОГРН;
	НовыйЛист.КОД_НО = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код");
	НовыйЛист.П_ИНН = СведенияОбОрганизации.ИННФЛ;
	НовыйЛист.ТЕЛЕФОН = СведенияОбОрганизации.ТелДом;
	Фамилия = СокрЛП(СведенияОбОрганизации.ФамилияИП);
	Имя = СокрЛП(СведенияОбОрганизации.ИмяИП);
	Отчество = СокрЛП(СведенияОбОрганизации.ОтчествоИП);
	
	Если ЗначениеЗаполнено(КодПричины) Тогда
		НовыйЛист.КОД_ПРИЧИНЫ = КодПричины;
	КонецЕсли;
	
	УстановитьДанныеПоРегистрацииВИФНС();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЛист2(НовыйЛист) Экспорт 
	
	НовыйЛист.UID = Новый УникальныйИдентификатор;
	НовыйЛист.П_ИНН1 = ТитульныйЛист[0].П_ИНН;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	
	Титульный = ТитульныйЛист[0];
	Организация = Объект.Организация;
	РегистрацияВИФНС = Объект.РегистрацияВИФНС;
	
	Титульный.КОД_НО = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегистрацияВИФНС, "Код");
	Представитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегистрацияВИФНС, "Представитель");
	Если ЗначениеЗаполнено(Представитель) Тогда
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьПредставителяПоФизЛицу(Объект, Представитель, Титульный, "ИНН_ПРЕДСТАВИТЕЛЯ");
		Титульный.ПРИЗНАК_НП_ПОДВАЛ = "2";
		Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегистрацияВИФНС, "ДокументПредставителя");
	Иначе
		УстановитьПредставителяПоОрганизации(Титульный);
		Титульный.ПРИЗНАК_НП_ПОДВАЛ = "1";
		Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ = "";
		Титульный.ИНН_ПРЕДСТАВИТЕЛЯ = "";
	КонецЕсли;
	
	Если ТекущийТипСтраницы = 1 Тогда
		ПредставлениеУведомления.Область("ПРИЗНАК_НП_ПОДВАЛ").Значение = Титульный.ПРИЗНАК_НП_ПОДВАЛ;
		ПредставлениеУведомления.Область("ТЕЛЕФОН").Значение = Титульный.ТЕЛЕФОН;
		ПредставлениеУведомления.Область("ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ").Значение = Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ;
		ПредставлениеУведомления.Область("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ").Значение = Титульный.ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ;
		ПредставлениеУведомления.Область("ИНН_ПРЕДСТАВИТЕЛЯ").Значение = Титульный.ИНН_ПРЕДСТАВИТЕЛЯ;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации(Титульный)
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьДанныеРуководителя(Объект);
	Титульный.ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Документы.УведомлениеОСпецрежимахНалогообложения.СохранитьДанныеЕНВД(ЭтотОбъект, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД4);
КонецПроцедуры

&НаКлиенте
Процедура РазделыЗаявленияПриАктивизацииСтроки(Элемент)
	
	Если ТекущийИдентификаторСтраницы = Элемент.ТекущиеДанные.UID И
		ТекущийТипСтраницы = Элемент.ТекущиеДанные.ТипСтраницы Тогда 
		
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.ТипСтраницы = 0 Тогда
		ПодчиненныеЭлементыДерева = Элемент.ТекущиеДанные.ПолучитьЭлементы();
		ТекущийИдентификаторСтраницы = ПодчиненныеЭлементыДерева[0].UID;
		ТекущийТипСтраницы = ПодчиненныеЭлементыДерева[0].ТипСтраницы;
		СформироватьМакетНаСервере();
		УстановитьДоступностьКнопок();
		Возврат;
	КонецЕсли;
	
	ТекущийИдентификаторСтраницы = Элемент.ТекущиеДанные.UID;
	ТекущийТипСтраницы = Элемент.ТекущиеДанные.ТипСтраницы;
	СформироватьМакетНаСервере();
	УстановитьДоступностьКнопок();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопок()
	Если Элементы.Разделы.ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТипСтраницы = Элементы.Разделы.ТекущиеДанные.ТипСтраницы;
	
	КМенюРО = Элементы.Разделы.КонтекстноеМеню;
	Если ТипСтраницы = 2 Тогда
		КМенюРО.Видимость = Истина;
		КМенюРО.ПодчиненныеЭлементы.РазделыЗаявленияКонтекстноеМенюДобавитьСтраницу.Видимость = Истина;
		КМенюРО.ПодчиненныеЭлементы.РазделыЗаявленияКонтекстноеМенюУдалитьСтраницу.Видимость = Истина;
		КМенюРО.ПодчиненныеЭлементы.РазделыЗаявленияКонтекстноеМенюДобавитьСтраницу.Доступность = Истина;
		КМенюРО.ПодчиненныеЭлементы.РазделыЗаявленияКонтекстноеМенюУдалитьСтраницу.Доступность = (СтраницыЛиста2.Количество() > 1);
	Иначе
		КМенюРО.Видимость = Ложь;
		КМенюРО.ПодчиненныеЭлементы.РазделыЗаявленияКонтекстноеМенюДобавитьСтраницу.Видимость = Ложь;
		КМенюРО.ПодчиненныеЭлементы.РазделыЗаявленияКонтекстноеМенюУдалитьСтраницу.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьМакетНаСервере()
	Документы.УведомлениеОСпецрежимахНалогообложения.СформироватьМакетОтчетаНаСервере(ЭтотОбъект, Объект.ИмяОтчета, "Форма2014_1", ПолучитьИмяОбласти(ТекущийТипСтраницы), ПолучитьИмяТаблицы(ТекущийТипСтраницы));
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИмяОбласти(ТекущийТипСтраницы)
	
	Если ТекущийТипСтраницы = 1 Тогда
		Возврат "ТитульныйЛист";
	ИначеЕсли ТекущийТипСтраницы = 2 Тогда
		Возврат "Страница2";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИмяТаблицы(ТекущийТипСтраницы)
	Если ТекущийТипСтраницы = 1 Тогда
		Возврат "ТитульныйЛист";
	ИначеЕсли ТекущийТипСтраницы = 2 Тогда
		Возврат "СтраницыЛиста2";
	КонецЕсли;
	
	Возврат "";
КонецФункции

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	ИмяОбласти = ПолучитьИмяОбласти(ТекущийТипСтраницы);
	Если Не ЗначениеЗаполнено(ИмяОбласти) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Область.Имя = "П_ИНН" Тогда
		НовИнн = Область.Значение;
		Для Каждого Стр Из СтраницыЛиста2 Цикл 
			Стр.П_ИНН1 = НовИнн;
		КонецЦикла;
	ИначеЕсли Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
	
	ИмяТаблицы = ПолучитьИмяТаблицы(ТекущийТипСтраницы);
	ПараметрыОтбора = Новый Структура("UID", ТекущийИдентификаторСтраницы);
	Данные = ЭтотОбъект[ИмяТаблицы].НайтиСтроки(ПараметрыОтбора);
	СтруктураЗаписи = Новый Структура(Область.Имя, Область.Значение);
	Если Данные.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Данные[0], СтруктураЗаписи);
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтрЧислоВхождений(Область.Имя, "ДобавитьСтраницу") > 0 Тогда
		ДобавитьСтраницу(Неопределено);
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "УдалитьСтраницу") > 0 Тогда
		УведомлениеОСпецрежимахНалогообложенияКлиент.УдалитьСтраницу(ЭтотОбъект);
	КонецЕсли;
	
	ОтборПоИмениОбласти = Новый Структура("Имя", Область.Имя);
	Поля = ПоляСОсобымПорядкомЗаполнения.НайтиСтроки(ОтборПоИмениОбласти);
	
	//Для полей адреса
	ИмяЯчейки = Лев(Область.Имя, СтрДлина(Область.Имя) - 1);
	НомерБлока = Прав(Область.Имя, 1);
	ВРЕГ_ИмяЯчейки = ВРЕГ(ИмяЯчейки);
	
	Если Поля.Количество() > 0 Тогда
		СтандартнаяОбработка = Ложь;
		НестандартнаяОбработка(Поля[0]);
		
	//форма заполнения листа адреса
	ИначеЕсли (ВРЕГ_ИмяЯчейки = "ИНДЕКС")
		ИЛИ (ВРЕГ_ИмяЯчейки = "РЕГИОН") 
		ИЛИ (ВРЕГ_ИмяЯчейки = "РАЙОН") 
		ИЛИ (ВРЕГ_ИмяЯчейки = "ГОРОД") 
		ИЛИ (ВРЕГ_ИмяЯчейки = "НАСЕЛЕННЫЙПУНКТ") 
		ИЛИ (ВРЕГ_ИмяЯчейки = "УЛИЦА")
		ИЛИ (ВРЕГ_ИмяЯчейки = "ДОМ") 
		ИЛИ (ВРЕГ_ИмяЯчейки = "КОРПУС") 
		ИЛИ (ВРЕГ_ИмяЯчейки = "КВАРТИРА") Тогда 
		
		СтандартнаяОбработка = Ложь;
		ИмяТаблицы = "СтраницыЛиста2";
		РоссийскийАдрес = Новый Соответствие;
		
		РоссийскийАдрес.Вставить("Индекс",	        ПредставлениеУведомления.Области["Индекс" + НомерБлока].Значение);
		РоссийскийАдрес.Вставить("Регион",          ПредставлениеУведомления.Области["Регион" + НомерБлока].Значение);
		РоссийскийАдрес.Вставить("КодРегиона",      ПредставлениеУведомления.Области["Регион" + НомерБлока].Значение);
		РоссийскийАдрес.Вставить("Район",           ПредставлениеУведомления.Области["Район" + НомерБлока].Значение);
		РоссийскийАдрес.Вставить("Город",           ПредставлениеУведомления.Области["Город" + НомерБлока].Значение);
		РоссийскийАдрес.Вставить("НаселенныйПункт", ПредставлениеУведомления.Области["НаселенныйПункт" + НомерБлока].Значение);
		РоссийскийАдрес.Вставить("Улица",           ПредставлениеУведомления.Области["Улица" + НомерБлока].Значение);
		РоссийскийАдрес.Вставить("Дом",             ПредставлениеУведомления.Области["Дом" + НомерБлока].Значение);
		РоссийскийАдрес.Вставить("Корпус",          ПредставлениеУведомления.Области["Корпус" + НомерБлока].Значение);
		РоссийскийАдрес.Вставить("Квартира",        ПредставлениеУведомления.Области["Квартира" + НомерБлока].Значение);
		
		Если Регионы.Количество() = 0 Тогда
			ЗаполнитьРегионыНаСервере();
		КонецЕсли;
		
		Регион = Регионы.НайтиСтроки(Новый Структура("Код", СокрЛП(РоссийскийАдрес["КодРегиона"])));
		
		Если Регион.Количество() > 0 Тогда
			
			РоссийскийАдрес["Регион"] = Регион[0].Наим;
			
		КонецЕсли;
		
		ЗначенияПолей = Новый СписокЗначений;
		
		ЗначенияПолей.Добавить(РоссийскийАдрес["Индекс"],          "Индекс");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Регион"],          "Регион");
		ЗначенияПолей.Добавить(РоссийскийАдрес["КодРегиона"],      "КодРегиона");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Район"],           "Район");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Город"],           "Город");
		ЗначенияПолей.Добавить(РоссийскийАдрес["НаселенныйПункт"], "НаселенныйПункт");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Улица"],           "Улица");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Дом"],             "Дом");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Корпус"],          "Корпус");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Квартира"],        "Квартира");
		
		ПредставлениеАдреса = РегламентированнаяОтчетностьКлиентСервер.ПредставлениеАдресаВФормате9Запятых("643," + РоссийскийАдрес["Индекс"] + ","
		+ РоссийскийАдрес["Регион"] + ","
		+ РоссийскийАдрес["Район"] + ","
		+ РоссийскийАдрес["Город"] + ","
		+ РоссийскийАдрес["НаселенныйПункт"] + ","
		+ РоссийскийАдрес["Улица"] + ","
		+ РоссийскийАдрес["Дом"] + ","
		+ РоссийскийАдрес["Корпус"] + ","
		+ РоссийскийАдрес["Квартира"]);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок",               "Ввод адреса");
		ПараметрыФормы.Вставить("ЗначенияПолей", 		   ЗначенияПолей);
		ПараметрыФормы.Вставить("Представление", 		   ПредставлениеАдреса);
		ПараметрыФормы.Вставить("ВидКонтактнойИнформации", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресОрганизации"));
			
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("РоссийскийАдрес", РоссийскийАдрес);
		ДополнительныеПараметры.Вставить("НомерБлока", НомерБлока);
		ДополнительныеПараметры.Вставить("ИмяТаблицы", ИмяТаблицы);
		
		ТипЗначения = Тип("ОписаниеОповещения");
		ПараметрыКонструктора = Новый Массив(3);
		ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
		ПараметрыКонструктора[1] = ЭтотОбъект;
		ПараметрыКонструктора[2] = ДополнительныеПараметры;
		
		Оповещение = Новый (ТипЗначения, ПараметрыКонструктора);
		
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент").ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, , Оповещение);
		
	КонецЕсли;
	
	Если Область.Имя = "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОткрытьФормуВыбораФИО(ЭтотОбъект, СтандартнаяОбработка, "ПредставлениеУведомления", "ТитульныйЛист");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(Результат, Параметры) Экспорт
	
	ОбновитьАдресВТабличномДокументе(Результат, Параметры.РоссийскийАдрес, Параметры.НомерБлока, Параметры.ИмяТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьАдресВТабличномДокументе(Результат, РоссийскийАдрес, НомерБлока, ИмяТаблицы)
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		// Обход ошибки платформы: в веб-клиенте, в результате выполнения процедуры "СформироватьАдрес"
		// общего модуля "РегламентированнаяОтчетностьВызовСервера", не изменяются значения ключей
		// соответствия "РоссийскийАдрес", передаваемого в качестве параметра.
		РоссийскийАдрес_ = РоссийскийАдрес;
		
		РегламентированнаяОтчетностьВызовСервера.СформироватьАдрес(Результат.КонтактнаяИнформация, РоссийскийАдрес_);
		
		ПредставлениеУведомления.Области["Индекс" + НомерБлока].Значение = РоссийскийАдрес_["Индекс"];
		ПредставлениеУведомления.Области["Регион" + НомерБлока].Значение = РоссийскийАдрес_["КодРегиона"];
		ПредставлениеУведомления.Области["Район" + НомерБлока].Значение = РоссийскийАдрес_["Район"];
		ПредставлениеУведомления.Области["Город" + НомерБлока].Значение = РоссийскийАдрес_["Город"];
		ПредставлениеУведомления.Области["НаселенныйПункт" + НомерБлока].Значение = РоссийскийАдрес_["НаселенныйПункт"];
		ПредставлениеУведомления.Области["Улица" + НомерБлока].Значение = РоссийскийАдрес_["Улица"];
		ПредставлениеУведомления.Области["Дом" + НомерБлока].Значение = РоссийскийАдрес_["Дом"];
		ПредставлениеУведомления.Области["Корпус" + НомерБлока].Значение = РоссийскийАдрес_["Корпус"];
		ПредставлениеУведомления.Области["Квартира" + НомерБлока].Значение = РоссийскийАдрес_["Квартира"];
		
		ПараметрыОтбора = Новый Структура("UID", ТекущийИдентификаторСтраницы);
		Данные = ЭтотОбъект[ИмяТаблицы].НайтиСтроки(ПараметрыОтбора);
		Если Данные.Количество() > 0 Тогда
			СтрокаДанных = Данные[0];
			СтрокаДанных["Индекс" + НомерБлока] = РоссийскийАдрес_["Индекс"];
			СтрокаДанных["Регион" + НомерБлока] = РоссийскийАдрес_["КодРегиона"];
			СтрокаДанных["Район" + НомерБлока] = РоссийскийАдрес_["Район"];
			СтрокаДанных["Город" + НомерБлока] = РоссийскийАдрес_["Город"];
			СтрокаДанных["НаселенныйПункт" + НомерБлока] = РоссийскийАдрес_["НаселенныйПункт"];
			СтрокаДанных["Улица" + НомерБлока] = РоссийскийАдрес_["Улица"];
			СтрокаДанных["Дом" + НомерБлока] = РоссийскийАдрес_["Дом"];
			СтрокаДанных["Корпус" + НомерБлока] = РоссийскийАдрес_["Корпус"];
			СтрокаДанных["Квартира" + НомерБлока] = РоссийскийАдрес_["Квартира"];
		КонецЕсли;
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРегионыНаСервере()
	
	РегламентированнаяОтчетность.ЗаполнитьРегионы(Регионы);
	
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработка(Инфо)
	Если Инфо.Обработчик = "ОбработкаСписка" Тогда
		ОбработкаСписка(Инфо);
	ИначеЕсли Инфо.Обработчик = "ОбработкаКодаНО" Тогда
		ОбработкаКодаНО(Инфо);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаСписка(Инфо)
	ИмяНестандартнойОбласти = Инфо.Имя;
	НазваниеСписка = Инфо.ИмяФормы;
	
	СтруктураОтбора = Новый Структура("ИмяСписка", Инфо.ИмяСписка);
	Строки = ТаблицаЗначенийПредопределенныхРеквизитов.НайтиСтроки(СтруктураОтбора);
	ЗагружаемыеКоды.Очистить();
	Для Каждого Строка Из Строки Цикл 
		НоваяСтрока = ЗагружаемыеКоды.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",          НазваниеСписка);
	ПараметрыФормы.Вставить("ТаблицаЗначений",    ЗагружаемыеКоды);
	ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", ПредставлениеУведомления.Области[ИмяНестандартнойОбласти].Значение));
	ДополнительныеПараметры = Новый Структура("ИмяНестандартнойОбласти", ИмяНестандартнойОбласти);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаСпискаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаСпискаЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	ИмяНестандартнойОбласти = ДополнительныеПараметры.ИмяНестандартнойОбласти;
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяОбластиДоп = "";
	РезультатВыбораКод = СокрЛП(РезультатВыбора.Код);
	
	ПредставлениеУведомления.Области[ИмяНестандартнойОбласти].Значение = РезультатВыбораКод;
	ИмяОбласти = ПолучитьИмяОбласти(ТекущийТипСтраницы);
	ИмяТаблицы = ПолучитьИмяТаблицы(ТекущийТипСтраницы);
	ПараметрыОтбора = Новый Структура("UID", ТекущийИдентификаторСтраницы);
	Данные = ЭтотОбъект[ИмяТаблицы].НайтиСтроки(ПараметрыОтбора);
	СтруктураЗаписи = Новый Структура(ИмяНестандартнойОбласти, РезультатВыбораКод);
	Если Данные.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Данные[0], СтруктураЗаписи);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяОбластиДоп) Тогда 
		СтруктураЗаписи = Новый Структура(ИмяОбластиДоп, "");
		Если Данные.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(Данные[0], СтруктураЗаписи);
		КонецЕсли;
	КонецЕсли;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНО(Инфо)
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Инфо);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Инфо = ДополнительныеПараметры.Инфо;
	
	Если Результат <> Неопределено Тогда 
		Объект.РегистрацияВИФНС = Результат;
		ПредставлениеУведомления.Области[Инфо.Имя].Значение = КодНалоговогоОргана();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция КодНалоговогоОргана()
	УстановитьДанныеПоРегистрацииВИФНС();
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код");
КонецФункции

&НаКлиенте
Процедура ДобавитьСтраницу(Команда)
	
	Если ТекущийТипСтраницы = 2 Тогда
		ДобавитьСтраницуНаСервере();
		ПеренумероватьСтраницы();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтраницуНаСервере()
	Если ТекущийТипСтраницы = 2 Тогда
		КорневойУровень = Разделы.ПолучитьЭлементы();
		СписокЛистов2 = КорневойУровень[1].ПолучитьЭлементы();
		НовыйЛист = СтраницыЛиста2.Добавить();
		ЗаполнитьЛист2(НовыйЛист);
		Лист2 = СписокЛистов2.Добавить();
		Лист2.ИндексКартинки = 1;
		Лист2.ТипСтраницы = 2;
		Лист2.Наименование = "Стр. 2";
		Лист2.UID = НовыйЛист.UID;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция УдалитьСтраницуНаСервере(UID, ТипСтраницы)
	ОтборСтрок = Новый Структура("UID", UID);
	Таблица = ЭтотОбъект[ПолучитьИмяТаблицы(ТипСтраницы)];
	Строки = Таблица.НайтиСтроки(ОтборСтрок);
	Таблица.Удалить(Строки[0]);
	Возврат Таблица[0].UID;
КонецФункции

&НаКлиенте
Процедура УдалитьСтраницу() Экспорт
	НайденныйИД = РегламентированнаяОтчетностьКлиентСервер.НайтиИДВДереве(Разделы.ПолучитьЭлементы(), ТекущийИдентификаторСтраницы, UID_Пустой);
	Если ТекущийИдентификаторСтраницы = UID_Пустой Тогда 
		Возврат;
	КонецЕсли;
	ЭлементДерева = Разделы.НайтиПоИдентификатору(НайденныйИД);
	ТС = ЭлементДерева.ТипСтраницы;
	UID = ЭлементДерева.UID;
	ТекущиеДанныеРодитель = ЭлементДерева.ПолучитьРодителя();
	Если ТекущиеДанныеРодитель.ПолучитьЭлементы().Количество() <= 1 Тогда 
		Возврат;
	КонецЕсли;
	UID_новый = УдалитьСтраницуНаСервере(UID, ТС);
	Для Каждого Стр Из ТекущиеДанныеРодитель.ПолучитьЭлементы() Цикл 
		Если Стр.UID = UID Тогда
			ТекущиеДанныеРодитель.ПолучитьЭлементы().Удалить(Стр);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	ПеренумероватьСтраницы();
	УстановитьДоступностьКнопок();
	
	РегламентированнаяОтчетностьКлиент.УстановитьТекущуюСтрокуВДеревеРазделов(ЭтотОбъект, UID_новый);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПеренумероватьСтраницы()
	Листы = Разделы.ПолучитьЭлементы()[1].ПолучитьЭлементы();
	Номер = 1;
	Для Каждого Лист Из Листы Цикл 
		Лист.Наименование = "Стр. "+Номер;
		Номер = Номер + 1;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьПечатнуюФорму()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПечатьСразу();
КонецФункции

&НаКлиенте
Процедура ПечатьУведомления(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьУведомленияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
	Иначе
		ПФ = СформироватьПечатнуюФорму();
		Если ПФ <> Неопределено Тогда 
			ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьУведомленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПФ = СформироватьПечатнуюФорму();
		Если ПФ <> Неопределено Тогда 
			ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотр(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ПредварительныйПросмотрЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
		Возврат;
	ИначеЕсли Модифицированность Тогда 
		СохранитьДанные();
	КонецЕсли;
	
	МассивПечати = Новый Массив;
	МассивПечати.Добавить(Объект.Ссылка);
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.УведомлениеОСпецрежимахНалогообложения",
		"Уведомление", МассивПечати, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотрЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьДанные();
		МассивПечати = Новый Массив;
		МассивПечати.Добавить(Объект.Ссылка);
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.УведомлениеОСпецрежимахНалогообложения",
			"Уведомление", МассивПечати, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСДвухмернымШтрихкодомPDF417(Команда)
	РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФормуУведомленияОСпецрежимах(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция СформироватьВыгрузкуИПолучитьДанные() Экспорт 
	Выгрузка = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если Выгрузка = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Выгрузка = Выгрузка[0];
	Возврат Новый Структура("ТестВыгрузки,КодировкаВыгрузки,Данные,ИмяФайла", 
			Выгрузка.ТестВыгрузки, Выгрузка.КодировкаВыгрузки, 
			Отчеты[Объект.ИмяОтчета].ПолучитьМакет("TIFF_2014_1"),
			"1112017_5.03000_04.tif");
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Заполнить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗаполнениемОтчетаЗавершение", ЭтотОбъект);
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("Организация", Объект.Организация);
	ПараметрыОтчета.Вставить("КодНалоговогоОргана", Объект.РегистрацияВИФНС);
	
	ЭтаФормаИмя = ИДОтчета(ЭтаФорма.ИмяФормы);
	
	СтандартнаяОбработка = Истина;
	РегламентированнаяОтчетностьКлиентПереопределяемый.ПередЗаполнениемОтчета(
		ЭтаФормаИмя, ПараметрыОтчета, ЭтотОбъект, ОписаниеОповещения, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		ЗаполнитьАвтоНаСервере();
		Элементы.Разделы.Развернуть(Разделы.ПолучитьЭлементы()[1].ПолучитьИдентификатор(), Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаполнениемОтчетаЗавершение(ПараметрыЗаполнения, ДополнительныеПараметры) Экспорт
	ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения);
	Элементы.Разделы.Развернуть(Разделы.ПолучитьЭлементы()[1].ПолучитьИдентификатор(), Истина);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения = Неопределено)
	
	Если ПараметрыЗаполнения <> Неопределено Тогда
		Если ПараметрыЗаполнения.Свойство("НалоговыйОрган") И Объект.РегистрацияВИФНС <> ПараметрыЗаполнения.НалоговыйОрган Тогда
			Объект.РегистрацияВИФНС =  ПараметрыЗаполнения.НалоговыйОрган;
			ТитульныйЛист[0].КОД_НО = КодНалоговогоОргана();
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("Организация", 			     Объект.Организация);
	ПараметрыОтчета.Вставить("КодНалоговогоОргана",          Объект.РегистрацияВИФНС);
	ПараметрыОтчета.Вставить("ДатаПодписи",                  Объект.ДатаПодписи);
	ПараметрыОтчета.Вставить("УникальныйИдентификаторФормы", ЭтаФорма.УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("ПараметрыЗаполнения",          ПараметрыЗаполнения);
	
	ЭтаФормаИмя = ИДОтчета(ЭтаФорма.ИмяФормы);
	
	Контейнер = СформироватьКонтейнерДляАвтозаполнения();
	РегламентированнаяОтчетностьПереопределяемый.ЗаполнитьОтчет(ЭтаФормаИмя, Сред(ЭтаФорма.ИмяФормы, СтрНайти(ЭтаФорма.ИмяФормы, ".Форма.") + 7), ПараметрыОтчета, Контейнер);
	ЗагрузитьПодготовленныеДанные(Контейнер);
	Документы.УведомлениеОСпецрежимахНалогообложения.СформироватьДеревоЛистовЕНВДУведомления(ЭтотОбъект);
	СформироватьМакетНаСервере();
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИДОтчета(Знач ЭтаФормаИмя)
	
	Если СтрЧислоВхождений(ЭтаФормаИмя, "ВнешнийОтчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "ВнешнийОтчет.", "");
	ИначеЕсли СтрЧислоВхождений(ЭтаФормаИмя, "Отчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "Отчет.", "");
	КонецЕсли;
	ЭтаФормаИмя = Лев(ЭтаФормаИмя, СтрНайти(ЭтаФормаИмя, ".Форма.") - 1);
	
	Возврат ЭтаФормаИмя;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные(Контейнер)
	Контейнер.ДопСтроки.Колонки.Добавить("UID");
	Контейнер.ДопСтроки.Колонки.Добавить("П_ИНН1");
	
	ЗначениеВДанныеФормы(Контейнер.ДопСтроки, СтраницыЛиста2);
	
	Для Каждого Стр Из СтраницыЛиста2 Цикл 
		Стр.UID = Новый УникальныйИдентификатор;
		Стр.П_ИНН1 = ТитульныйЛист[0].П_ИНН;
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(ТитульныйЛист[0], Контейнер.Титульный);
	
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Функция СформироватьКонтейнерДляАвтозаполнения()
	Контейнер = Новый Структура();
	
	Таб = ДанныеФормыВЗначение(СтраницыЛиста2, Тип("ТаблицаЗначений"));
	Таб.Колонки.Удалить("UID");
	Таб.Колонки.Удалить("П_ИНН1");
	Контейнер.Вставить("ДопСтроки", Таб);
	
	Таб = ДанныеФормыВЗначение(ТитульныйЛист, Тип("ТаблицаЗначений"));
	Таб.Колонки.Удалить("UID");
	Таб.Колонки.Удалить("П_ИНН");
	Контейнер.Вставить("Титульный", ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Таб[0]));
	
	Возврат Контейнер;
КонецФункции

&НаСервере
Функция ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПроверитьДокументСВыводомВТаблицу(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ТаблицаОшибок = ПроверитьВыгрузкуНаСервере();
	Если ТаблицаОшибок.Количество() = 0 Тогда 
		ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибок не обнаружено");
	Иначе
		ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.НавигацияПоОшибкам", Новый Структура("ТаблицаОшибок", ТаблицаОшибок), ЭтотОбъект, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВыгружатьСОшибками(Команда)
	РазрешитьВыгружатьСОшибками = Не РазрешитьВыгружатьСОшибками;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		Если Параметр.ИмяСтраницы = "ТитульныйЛист" Тогда 
			ТекущийТипСтраницы = 1;
		ИначеЕсли Параметр.ИмяСтраницы = "Лист2" Тогда 
			ТекущийТипСтраницы = 2;
		КонецЕсли;
		
		ТекущийИдентификаторСтраницы = Параметр.УИДСтраницы;
		СформироватьМакетНаСервере();
		Элементы.ПредставлениеУведомления.ТекущаяОбласть = ПредставлениеУведомления.Области.Найти(Параметр.ИмяОбласти);
		УстановитьДоступностьКнопок();
		Активизировать();
		Если ТипЗнч(Источник) = Тип("ФормаКлиентскогоПриложения") И Источник.Открыта() Тогда 
			Источник.Закрыть( );
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры
