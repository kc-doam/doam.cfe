﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеОтказОтУСН.Форма.Форма2014_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2014_1";
	Стр.ОписаниеФормы = "26.2-3/приказ ФНС от 02.11.2012 N ММВ-7-3/829@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ПечатьСразу_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат СформироватьМакет_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2014_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2014_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("Организация", Объект.Организация);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2014_1(Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция СформироватьМакет_Форма2014_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УведомлениеОСпецрежимах_"+Объект.ВидУведомления.Метаданные().Имя;
	
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма2014_1");
	ПараметрыМакета = МакетУведомления.Параметры;
	СтруктураПараметров = Объект.ДанныеУведомления.Получить();
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Объект.ДатаПодписи, "ДатаПодписи_", ПараметрыМакета);
	Если СтруктураПараметров.Свойство("ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ") Тогда 
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ, "ДокументПредставителя_", ПараметрыМакета, 120);
	КонецЕсли;
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ТЕЛЕФОН, "Телефон_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантФамилия, "ОргПодписантФамилия_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантИмя, "ОргПодписантИмя_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантОтчество, "ОргПодписантОтчество_", ПараметрыМакета, 20);
	Если СтруктураПараметров.Свойство("ПРИЗНАК_НП_ПОДВАЛ") Тогда
		ПараметрыМакета.ПризнакПредставителя = СтруктураПараметров.ПРИЗНАК_НП_ПОДВАЛ;
	КонецЕсли;
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.КОД_НО, "КОД_НО_", ПараметрыМакета, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.П_ИНН, "ИНН_", ПараметрыМакета, 12);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ОРГАНИЗАЦИЯ, "ОрганизацияНазвание_", ПараметрыМакета, 160);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.П_КПП, "КПП_", ПараметрыМакета, 9);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ГОД_ОТКАЗА_ОТ_УСН, "ГодПерехода_", ПараметрыМакета, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(СтруктураПараметров.ПРИЛОЖЕНО_ЛИСТОВ, "ПриложеноЛистов_", ПараметрыМакета, 3);
	
	ПечатнаяФорма.Вывести(МакетУведомления);
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразу_Форма2014_1(Объект)
	
	ПечатнаяФорма = СформироватьМакет_Форма2014_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(СведенияОтправки)
	Префикс = "SR_UOUSN";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Процедура Проверить_Форма2014_1(Данные, УникальныйИдентификатор)
	Титульный = Данные;
	
	Если Не ЗначениеЗаполнено(Титульный.ГОД_ОТКАЗА_ОТ_УСН) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан год отказа от УСН", УникальныйИдентификатор);
		ВызватьИсключение "";
	КонецЕсли;
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация));
	
	Если ОсновныеСведения.ЭтоПБОЮЛ Тогда
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПФЛ(Объект, ОсновныеСведения);
	Иначе 
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	КонецЕсли;
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьОбщиеДанные(Объект, ОсновныеСведения);
	Данные = Объект.ДанныеУведомления.Получить();
	
	ОсновныеСведения.Вставить("ГодПер", Данные.ГОД_ОТКАЗА_ОТ_УСН);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДанныеУведомления.Вставить("Организация", Объект.Организация);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2014_1(ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2014_1");
	ЗаполнитьДанными_Форма2014_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ЗаполнитьДанными_Форма2014_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(Параметры, ДеревоВыгрузки);
КонецПроцедуры

Функция ПроверитьДокументСВыводомВТаблицу_Форма2014_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	
	Титульный = Данные;
	Если Не ЗначениеЗаполнено(Титульный.ГОД_ОТКАЗА_ОТ_УСН) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан год отказа от УСН", "Титульный", "ГОД_ОТКАЗА_ОТ_УСН"));
	КонецЕсли;
	Если ЗначениеЗаполнено(Титульный.ГОД_ОТКАЗА_ОТ_УСН) И (СтрДлина(СокрЛП(Титульный.ГОД_ОТКАЗА_ОТ_УСН)) <> 4 Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Титульный.ГОД_ОТКАЗА_ОТ_УСН)) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан год отказа от УСН", "Титульный", "ГОД_ОТКАЗА_ОТ_УСН"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.КОД_НО) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан налоговый орган", "Титульный", "КОД_НО"));
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация) Тогда 
		Если Не ЗначениеЗаполнено(Титульный.П_ИНН) Или Не ЗначениеЗаполнено(Титульный.П_КПП) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН/КПП", "Титульный", "П_ИНН"));
		КонецЕсли;
		Если ЗначениеЗаполнено(Титульный.П_ИНН) И (СтрДлина(Титульный.П_ИНН) <> 10 Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Титульный.П_ИНН)) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН", "Титульный", "П_ИНН"));
		КонецЕсли;
		Если ЗначениеЗаполнено(Титульный.П_КПП) И (СтрДлина(Титульный.П_КПП) <> 9 Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Титульный.П_КПП)) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан КПП", "Титульный", "П_КПП"));
		КонецЕсли;
	Иначе
		Если Не ЗначениеЗаполнено(Титульный.П_ИНН) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН", "Титульный", "П_ИНН"));
		КонецЕсли;
		Если ЗначениеЗаполнено(Титульный.П_ИНН) И (СтрДлина(Титульный.П_ИНН) <> 12 Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Титульный.П_ИНН)) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН", "Титульный", "П_ИНН"));
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТаблицаОшибок;
КонецФункции

#КонецОбласти
#КонецЕсли