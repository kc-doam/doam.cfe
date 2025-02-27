﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Ложь;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеНалоговаяЛьготаРегИнвестПроекты.Форма.Форма2017_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2017_1";
	Стр.ОписаниеФормы = "Форму уведомления о контролируемых иностранных компаниях в соответствии с приказом ФНС России от 27.12.2016 № ММВ-7-3/719@";
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2017_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2017_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2017_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2017_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2017_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2017_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2017_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2017_1(Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2017_1(СведенияОтправки)
	Префикс = "NO_ZVRIP";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2017_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	Если Не ЗначениеЗаполнено(Титульная.ИННЮЛ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН на титульном листе", "Титульная", "ИННЮЛ"));
	ИначеЕсли СтрДлина(СокрЛП(Титульная.ИННЮЛ)) <> 10 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН на титульном листе", "Титульная", "ИННЮЛ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КПП) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан КПП на титульном листе", "Титульная", "КПП"));
	ИначеЕсли СтрДлина(СокрЛП(Титульная.КПП)) <> 9 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан КПП на титульном листе", "Титульная", "КПП"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КодНО) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан налоговый орган", "Титульная", "КодНО"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ОтчетГод) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан отчетный год", "Титульная", "ОтчетГод"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ПоМесту) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код по месту нахождения(учета)", "Титульная", "ПоМесту"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ПризЗаяв) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан отчетный код декларации", "Титульная", "ПризЗаяв"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.НаимОрг) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование организации", "Титульная", "НаимОрг"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Период) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан отчетный период", "Титульная", "Период"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДатаДок) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата составления", "Титульная", "ДатаДок"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ПрПодп) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак подписанта", "Титульная", "ПрПодп"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.Фамилия) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана фамилия подписанта", "Титульная", "Фамилия"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Имя) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано имя подписанта", "Титульная", "Имя"));
	КонецЕсли;
	Если Титульная.ПрПодп = "2" И (Не ЗначениеЗаполнено(Титульная.НаимДок)) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан документ подписанта", "Титульная", "НаимДок"));
	КонецЕсли;
	
	Для Каждого ДопЛист Из Данные.ДанныеМногостраничныхРазделов.ДопЛист Цикл 
		ДопЛистЗначение = ДопЛист.Значение;
		Если Не ЗначениеЗаполнено(ДопЛистЗначение.НаимИП) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование инвеститицонного проекта ", "ДопЛист", "НаимИП", ДопЛистЗначение.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ДопЛистЗначение.ОбщСтоимУслугР) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан объем вложений", "ДопЛист", "ОбщСтоимУслугР", ДопЛистЗначение.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ДопЛистЗначение.ДатаНачКапВл) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата начала капитальных вложений", "ДопЛист", "ДатаНачКапВл", ДопЛистЗначение.УИД));
		КонецЕсли;
		Если (ТипЗнч(ДопЛистЗначение.СрокГод) = Тип("Число") И (ДопЛистЗначение.СрокГод < 1 Или ДопЛистЗначение.СрокГод > 5)) Или ДопЛистЗначение.СрокГод = Неопределено Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан срок", "ДопЛист", "СрокГод", ДопЛистЗначение.УИД));
		ИначеЕсли ДопЛистЗначение.СрокГод = Неопределено Тогда 
			ДопЛистЗначение.СрокГод = 0;
		КонецЕсли;
		Если ТипЗнч(ДопЛистЗначение.СрокМес) = Тип("Число") И ДопЛистЗначение.СрокМес > 12 Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан срок", "ДопЛист", "СрокМес", ДопЛистЗначение.УИД));
		ИначеЕсли ДопЛистЗначение.СрокМес = Неопределено Тогда 
			ДопЛистЗначение.СрокМес = 0;
		КонецЕсли;
	КонецЦикла;
	
	ПризЗаяв = Титульная.ПризЗаяв;
	Для Каждого Регионы Из Данные.ДанныеМногостраничныхРазделов.Регионы Цикл 
		РегионыЗначение = Регионы.Значение;
		Если Не ЗначениеЗаполнено(РегионыЗначение.КодСубъект) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код субъекта РФ", "Регионы", "КодСубъект", РегионыЗначение.УИД));
		КонецЕсли;
		Если ПризЗаяв = "2" Тогда
			Если Не ЗначениеЗаполнено(РегионыЗначение.ОКТМО) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано ОКТМО", "Регионы", "ОКТМО", РегионыЗначение.УИД));
			ИначеЕсли СтрДлина(СокрЛП(РегионыЗначение.ОКТМО)) <> 8 И СтрДлина(СокрЛП(РегионыЗначение.ОКТМО)) <> 11 Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указано ОКТМО", "Регионы", "ОКТМО", РегионыЗначение.УИД));
			КонецЕсли;
		КонецЕсли;
		
		ДопСтроки = Данные.ДанныеДопСтрокБД.МнгСтр.НайтиСтроки(Новый Структура("УИД", РегионыЗначение.УИД));
		ИндДС = 0;
		Для Каждого ДопСтрока Из ДопСтроки Цикл 
			ИндДС = ИндДС + 1;
			Если Не ЗначениеЗаполнено(ДопСтрока.НаимТов) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование товара", "Регионы", "НаимТов___" + ИндДС, РегионыЗначение.УИД));
			КонецЕсли;
			Если Не ЗначениеЗаполнено(ДопСтрока.ОКПД2) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код ОКПД2", "Регионы", "ОКПД2___" + ИндДС, РегионыЗначение.УИД));
			КонецЕсли;
			Если ПризЗаяв = "2" И Не ЗначениеЗаполнено(ДопСтрока.КодДПИ) Тогда
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код полезного ископаемого", "Регионы", "КодДПИ___" + ИндДС, РегионыЗначение.УИД));
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ТаблицаОшибок;
КонецФункции

Процедура Проверить_Форма2017_1(Данные, УникальныйИдентификатор)
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2017_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура("ЭтоПБОЮЛ", Ложь);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	
	ОсновныеСведения.Вставить("ВерсПрог", РегламентированнаяОтчетность.НазваниеИВерсияПрограммы());
	ОсновныеСведения.Вставить("ДатаДок", Формат(Объект.ДатаПодписи, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("ФамилияПодп", Объект.ПодписантФамилия);
	ОсновныеСведения.Вставить("ИмяПодп", Объект.ПодписантИмя);
	ОсновныеСведения.Вставить("ОтчествоПодп", Объект.ПодписантОтчество);
	
	Данные = Объект.ДанныеУведомления.Получить();
	ОсновныеСведения.Вставить("КодНО", Данные.ДанныеУведомления.Титульная.КодНО);
	ОсновныеСведения.Вставить("ПрПодп", Данные.ДанныеУведомления.Титульная.ПрПодп);
	ОсновныеСведения.Вставить("ИННТитул", Данные.ДанныеУведомления.Титульная.ИННЮЛ);
	ОсновныеСведения.Вставить("ИННЮЛ", Данные.ДанныеУведомления.Титульная.ИННЮЛ);
	ОсновныеСведения.Вставить("ПризЗаяв", Данные.ДанныеУведомления.Титульная.ПризЗаяв);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2017_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2017_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2017_1(ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2017_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2017_1");
	ЗаполнитьДанными_Форма2017_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
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

Процедура ЗаполнитьДанными_Форма2017_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметрыСРазделами(Параметры, ДеревоВыгрузки);
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДополнитьПараметры(ДанныеУведомления);
	ЗаполнитьДаннымиУзелНов(ДанныеУведомления, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(ДеревоВыгрузки);
КонецПроцедуры

Процедура ДополнитьПараметры(Параметры)
	ОТЧ = Новый ОписаниеТипов("Число");
	Параметры.ДанныеУведомления.Титульная.Вставить("НомКоррВыгр", Формат(ОТЧ.ПривестиЗначение(Параметры.ДанныеУведомления.Титульная.НомКорр), "ЧН=0"));
	Для Каждого ДопЛист Из Параметры.ДанныеМногостраничныхРазделов.ДопЛист Цикл 
		ДопЛистЗначение = ДопЛист.Значение;
		ДопЛистЗначение.Вставить("СрокМесВыгр", Формат(ОТЧ.ПривестиЗначение(ДопЛистЗначение.СрокМес), "ЧН=0"));
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, Узел, ПараметрыТекущейСтраницы = Неопределено, УИДРодителя = Неопределено)
	СтрокиУзла = Новый Массив;
	Для Каждого Стр Из Узел.Строки Цикл
		СтрокиУзла.Добавить(Стр);
	КонецЦикла;
	
	Для Каждого Стр из СтрокиУзла Цикл
		Если Стр.Тип = "А" Или Стр.Тип = "A" Или Стр.Тип = "П" Тогда
			Если ЗначениеЗаполнено(Стр.Ключ) Тогда
				ЗначениеПоказателя = Неопределено;
				Если ПараметрыТекущейСтраницы <> Неопределено И ПараметрыТекущейСтраницы.Свойство(Стр.Ключ, ЗначениеПоказателя) Тогда 
					РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
				ИначеЕсли ПараметрыТекущейСтраницы = Неопределено 
					И ЗначениеЗаполнено(Стр.Раздел)
					И ПараметрыВыгрузки.ДанныеУведомления.Свойство(Стр.Раздел, ЗначениеПоказателя) Тогда 
					Если ЗначениеПоказателя.Свойство(Стр.Ключ, ЗначениеПоказателя) Тогда
						РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Стр.Тип = "С" ИЛИ Стр.Тип = "C" Тогда
			Если Стр.Многостраничность = Истина Тогда
				Многостраничность = Неопределено;
				Если ПараметрыВыгрузки.ДанныеМногостраничныхРазделов.Свойство(Стр.Раздел, Многостраничность)
					И ТипЗнч(Многостраничность) = Тип("СписокЗначений") Тогда
				
					Для Каждого СтрМнгч Из Многостраничность Цикл 
						Если УИДРодителя = Неопределено Или СтрМнгч.Значение.УИДРодителя = УИДРодителя Тогда 
							НовУзел = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Стр);
							ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, НовУзел, СтрМнгч.Значение, СтрМнгч.Значение.УИД);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			ИначеЕсли Стр.Многострочность = Истина Тогда 
				Многострочность = Неопределено;
				Если ПараметрыВыгрузки.ДанныеДопСтрокБД.Свойство(Стр.Раздел, Многострочность)
					И ТипЗнч(Многострочность) = Тип("ТаблицаЗначений") Тогда
					
					СтрокиМнгстр = Многострочность.НайтиСтроки(Новый Структура("УИД", УИДРодителя));
					Для Каждого СтрокаМнгстр Из СтрокиМнгстр Цикл
						НовУзел = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Стр);
						НовУзел.Многострочность = Ложь;
						ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, НовУзел, ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаМнгстр), УИДРодителя)
					КонецЦикла;
				КонецЕсли;
			Иначе
				ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, Стр, ПараметрыТекущейСтраницы, УИДРодителя)
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПоложитьВОбласти(Макет, Данные)
	ЗначОбл = Неопределено;
	Для Каждого Обл Из Макет.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник И Обл.СодержитЗначение = Истина Тогда 
			Если Данные.Свойство(Обл.Имя, ЗначОбл) Тогда 
				Обл.Значение = ЗначОбл;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция СформироватьСписокЛистовФорма2017_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	ИННКПП = Новый Структура();
	ИННКПП.Вставить("ИННЮЛ", СтруктураПараметров.ДанныеУведомления.Титульная.ИННЮЛ);
	ИННКПП.Вставить("КПП", СтруктураПараметров.ДанныеУведомления.Титульная.КПП);
	
	НомСтр = 2;
	МакетПФ = Отчеты.РегламентированноеУведомлениеНалоговаяЛьготаРегИнвестПроекты.ПолучитьМакет("Печать_Форма2017_1_Титульная");
	ПоложитьВОбласти(МакетПФ, СтруктураПараметров.ДанныеУведомления.Титульная);
	ПечатнаяФорма.Вывести(МакетПФ);
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
	
	Для Каждого Л1 Из СтруктураПараметров.ДанныеМногостраничныхРазделов.ДопЛист Цикл 
		Если Не ЗначениеЗаполнено(Л1.Значение.НаимИП) Тогда 
			Прервать;
		КонецЕсли;
		
		Для Каждого Л2 Из СтруктураПараметров.ДанныеМногостраничныхРазделов.Регионы Цикл 
			Если Л2.Значение.УИДРодителя <> Л1.Значение.УИД Тогда 
				Продолжить;
			КонецЕсли;
			
			МакетПФ = Отчеты.РегламентированноеУведомлениеНалоговаяЛьготаРегИнвестПроекты.ПолучитьМакет("Печать_Форма2017_1_ДопЛист");
			ПоложитьВОбласти(МакетПФ, ИННКПП);
			ПоложитьВОбласти(МакетПФ, Л1.Значение);
			ПоложитьВОбласти(МакетПФ, Л2.Значение);
			МакетПФ.Области["НомСтр"].Значение = Формат(НомСтр, "ЧЦ=3; ЧВН=");
			НомСтр = НомСтр + 1;
			
			ДопСтроки = СтруктураПараметров.ДанныеДопСтрокБД.МнгСтр.НайтиСтроки(Новый Структура("УИД", Л2.Значение.УИД));
			Инд = 0;
			НеобходимаПечать = Истина;
			Для Каждого ДопСтрока из ДопСтроки Цикл
				Если Не ЗначениеЗаполнено(ДопСтрока.НаимТов) Тогда 
					Продолжить;
				КонецЕсли;
				
				Инд = Инд + 1;
				МакетПФ.Области["НаимТов_" + Инд].Значение = ДопСтрока.НаимТов;
				МакетПФ.Области["ОКПД2_" + Инд].Значение = ДопСтрока.ОКПД2;
				МакетПФ.Области["КодДПИ_" + Инд].Значение = ДопСтрока.КодДПИ;
				НеобходимаПечать = Ложь;
				
				Если Инд = 5 Тогда
					ПечатнаяФорма.Вывести(МакетПФ);
					УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
					МакетПФ = Отчеты.РегламентированноеУведомлениеНалоговаяЛьготаРегИнвестПроекты.ПолучитьМакет("Печать_Форма2017_1_ДопЛист");
					ПоложитьВОбласти(МакетПФ, ИННКПП);
					ПоложитьВОбласти(МакетПФ, Л1.Значение);
					ПоложитьВОбласти(МакетПФ, Л2.Значение);
					МакетПФ.Области["НомСтр"].Значение = Формат(НомСтр, "ЧЦ=3; ЧВН=");
					НомСтр = НомСтр + 1;
					Инд = 0;
				КонецЕсли;
			КонецЦикла;
			
			Если Инд > 0 Или НеобходимаПечать Тогда 
				ПечатнаяФорма.Вывести(МакетПФ);
				УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Листы;
КонецФункции

Процедура КонвертацияИзРегламентированногоОтчета(ВыборкаСтрока) Экспорт
	Попытка
		Если ВыборкаСтрока.ВыбраннаяФорма = "ФормаОтчета2017Кв1" Тогда
			КонвертироватьНаСервере_2017(ВыборкаСтрока.Ссылка);
		КонецЕсли;
	Исключение
	КонецПопытки;
КонецПроцедуры

Процедура КонвертироватьНаСервере_2017(Ссылка) Экспорт 
	Попытка
		ДанныеОтчета = Ссылка.ДанныеОтчета.Получить();
		НовоеУведомление = Документы.УведомлениеОСпецрежимахНалогообложения.СоздатьДокумент();
		НовоеУведомление.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПримененииНалоговойЛьготыУчастникамиРегиональныхИнвестиционныхПроектов;
		НовоеУведомление.Организация = Ссылка.Организация;
		НовоеУведомление.ИмяОтчета = "РегламентированноеУведомлениеНалоговаяЛьготаРегИнвестПроекты";
		НовоеУведомление.ИмяФормы = "Форма2017_1";
		НовоеУведомление.ДатаПодписи = ДанныеОтчета.ДанныеУведомления.Титульная.ДатаДок;
		НовоеУведомление.Дата = ТекущаяДатаСеанса();
		НовоеУведомление.РегистрацияВИФНС = УведомлениеОСпецрежимахНалогообложенияПовтИсп.ПолучитьРегистрациюВИФНСПоКоду(ДанныеОтчета.ДанныеУведомления.Титульная.КодНО, НовоеУведомление.Организация);
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ИдентификаторыОбычныхСтраниц", ДанныеОтчета.ИдентификаторыОбычныхСтраниц);
		СтруктураПараметров.Вставить("ДанныеДопСтрокБД", ДанныеОтчета.ДанныеДопСтрокБД);
		СтруктураПараметров.Вставить("ДеревоСтраниц", ДанныеОтчета.ДеревоРазделов);
		СтруктураПараметров.Вставить("ДанныеМногостраничныхРазделов", ДанныеОтчета.ДанныеМногостраничныхРазделов);
		СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеОтчета.ДанныеУведомления);
		
		ДанныеОтчета.ДеревоРазделов.Колонки.Добавить("МакетыПФ", Новый ОписаниеТипов("Строка"));
		
		НовоеУведомление.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НовоеУведомление);
		
		ЗаписьСоответствия = РегистрыСведений["СоответствиеРегОтчетовУведомлениям"].СоздатьМенеджерЗаписи();
		ЗаписьСоответствия.РегОтчет = Ссылка;
		ЗаписьСоответствия.Прочитать();
		ЗаписьСоответствия.РегОтчет = Ссылка;
		ЗаписьСоответствия.Уведомление = НовоеУведомление.Ссылка;
		ЗаписьСоответствия.Записать(Истина);
	Исключение
		Ошибка = ИнформацияОбОшибке();
		СтрОш = НСтр("ru = 'ошибка при преобразовании: Заявление о применении налоговой льготы участниками региональных инвестиционных проектов'", ОбщегоНазначения.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(СтрОш, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
КонецПроцедуры

#КонецОбласти
#КонецЕсли
