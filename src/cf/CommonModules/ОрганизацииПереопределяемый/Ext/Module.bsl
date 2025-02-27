﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОрганизацииСервер

// Переопределяет структуру, содержащую сведения о регистрационной информации организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные - Структура -
//                  см. ОрганизацииСервер.РегистрационныеДанныеОрганизации
// Пример:
//       СведенияОбОрганизации = ОрганизацииСервер.СведенияОбОрганизации(Организация);
//
//	СвойстваОрганизации = СтрРазделить(Поля, ",", Ложь);
//	
//	Запрос = Новый Запрос;
//	Запрос.УстановитьПараметр("Ссылка", Организация);
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	_ДемоОрганизации.Ссылка КАК Ссылка,
//		|	_ДемоОрганизации.ВерсияДанных КАК ВерсияДанных,
//		|	_ДемоОрганизации.ПометкаУдаления КАК ПометкаУдаления,
//		|	_ДемоОрганизации.Код КАК Код,
//		|	_ДемоОрганизации.Наименование КАК Наименование,
//		|	_ДемоОрганизации.БИК КАК БИК,
//		|	_ДемоОрганизации.ГлавныйБухгалтер КАК ГлавныйБухгалтер,
//		|	_ДемоОрганизации.Директор КАК Директор,
//		|	_ДемоОрганизации.ИндивидуальныйПредприниматель КАК ИндивидуальныйПредприниматель,
//		|	_ДемоОрганизации.ИНН КАК ИНН,
//		|	_ДемоОрганизации.ИнформационноеОбслуживание КАК ИнформационноеОбслуживание,
//		|	_ДемоОрганизации.КорреспондентскийСчет КАК КорреспондентскийСчет,
//		|	_ДемоОрганизации.КПП КАК КПП,
//		|	_ДемоОрганизации.НаименованиеПолное КАК НаименованиеПолное,
//		|	_ДемоОрганизации.НаименованиеСокращенное КАК НаименованиеСокращенное,
//		|	_ДемоОрганизации.ОГРН КАК ОГРН,
//		|	_ДемоОрганизации.Префикс КАК Префикс,
//		|	_ДемоОрганизации.РасчетныйСчет КАК РасчетныйСчет,
//		|	_ДемоОрганизации.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
//		|	_ДемоОрганизации.ПроизводственныйКалендарь КАК ПроизводственныйКалендарь,
//		|	_ДемоОрганизации.Предопределенный КАК Предопределенный,
//		|	_ДемоОрганизации.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
//		|ИЗ
//		|	Справочник._ДемоОрганизации КАК _ДемоОрганизации
//		|ГДЕ
//		|	_ДемоОрганизации.Ссылка = &Ссылка";
//	
//	РезультатЗапроса = Запрос.Выполнить();
//	
//	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
//	
//	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
//		
//		Для каждого Элемент Из СвойстваОрганизации Цикл
//			
//			Если РезультатЗапроса.Колонки.Найти(Элемент) <> Неопределено Тогда
//				
//				РегистрационныеДанные.Вставить(Элемент, ВыборкаДетальныеЗаписи[Элемент]);
//				
//			КонецЕсли;
//			
//		КонецЦикла;
//		
//	КонецЕсли;
Процедура ПриОпределенииРегистрационныхДанныхОрганизации(Организация, Поля, Дата, РегистрационныеДанные) Экспорт
	
	
	
КонецПроцедуры

// Возвращает структуру, содержащую сведения о дополнительной информации организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  ДополнительныеСведения - Структура -
//                  см. ОрганизацииСервер.ДополнительныеСведенияОрганизации.
Процедура ПриОпределенииДополнительныхСведенийОрганизации(Организация, Поля, Дата, ДополнительныеСведения) Экспорт
	
	

КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - Структура -
//                  см. ОрганизацииСервер.КонтактнаяИнформацияОрганизации.
Процедура ПриОпределенииКонтактнойИнформацииОрганизации(Организация, Поля, Дата, КонтактнаяИнформация) Экспорт
	

КонецПроцедуры

// Переопределяет структуру, содержащую сведения о банковской информации организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  БанковскийСчет - Структура -
//                  см. ОрганизацииСервер.БанковскийСчетОрганизации.
Процедура ПриОпределенииБанковскогоСчетаОрганизации(Организация, Поля, Дата, БанковскийСчет) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СведенияОбОбособленномПодразделении

// Переопределяет структуру, содержащую сведения о регистрационных данных обособленного подразделения.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные - Структура -
//                  см. ОрганизацииСервер.РегистрационныеДанныеОбособленногоПодразделения.
Процедура ПриОпределенииРегистрационныхДанныхОбособленногоПодразделения(Организация, Поля, Дата, РегистрационныеДанные) Экспорт	
	
КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации обособленного подразделения.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - Структура -
//                  см. ОрганизацииСервер.КонтактнаяИнформацияОбособленногоПодразделения.
Процедура ПриОпределенииКонтактнойИнформацииОбособленногоПодразделения(Организация, Поля, Дата, КонтактнаяИнформация) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СведенияОбИностраннойОрганизации

// Переопределяет структуру, содержащую сведения о регистрационной информации иностранной организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные - Структура -
//                  см. ОрганизацииСервер.РегистрационныеДанныеИностраннойОрганизации.
Процедура ПриОпределенииРегистрационныхДанныхИностраннойОрганизации(Организация, Поля, Дата, РегистрационныеДанные) Экспорт
	
КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации иностранной организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - Структура -
//                  см. ОрганизацииСервер.КонтактнаяИнформацияИностраннойОрганизации.
Процедура ПриОпределенииКонтактнойИнформацииИностраннойОрганизации(Организация, Поля, Дата, КонтактнаяИнформация) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СведенияОбИндивидуальномПредпринимателе

// Переопределяет структуру, содержащую сведения о регистрационной информации индивидуального предпринимателя.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные - Структура -
//                  см. ОрганизацииСервер.РегистрационныеДанныеИндивидуальногоПредпринимателя.
Процедура ПриОпределенииРегистрационныхДанныхИндивидуальногоПредпринимателя(Организация, Поля, Дата, РегистрационныеДанные) Экспорт
			
КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации индивидуального предпринимателя.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - Структура -
//                  см. ОрганизацииСервер.КонтактнаяИнформацияИндивидуальногоПредпринимателя.
Процедура ПриОпределенииКонтактнойИнформацииИндивидуальногоПредпринимателя(Организация, Поля, Дата, КонтактнаяИнформация) Экспорт
		
КонецПроцедуры

#КонецОбласти

#Область СведенияОРуководителеОрганизации

// Переопределяет структуру, содержащую сведения о регистрационной информации руководителя организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные - Структура -
//                  см. ОрганизацииСервер.РегистрационныеДанныеРуководителяОрганизации.
Процедура ПриОпределенииРегистрационныхДанныхРуководителяОрганизации(Организация, Поля, Дата, РегистрационныеДанные) Экспорт	
	

КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации руководителя организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - Структура -
//                  см. ОрганизацииСервер.КонтактнаяИнформацияРуководителяОрганизации.
Процедура ПриОпределенииКонтактнойИнформацииРуководителяОрганизации(Организация, Поля, Дата, КонтактнаяИнформация) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СведенияОГлавномБухгалтере

// Переопределяет структуру, содержащую сведения о регистрационной информации главного бухгалтера.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные - Структура -
//                  см. ОрганизацииСервер.РегистрационныеДанныеГлавногоБухгалтера.
Процедура ПриОпределенииРегистрационныхДанныхГлавногоБухгалтера(Организация, Поля, Дата, РегистрационныеДанные) Экспорт
		
КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации главного бухгалтера.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - Структура -
//                  см. ОрганизацииСервер.КонтактнаяИнформацияГлавногоБухгалтера.
Процедура ПриОпределенииКонтактнойИнформацииГлавногоБухгалтера(Организация, Поля, Дата, КонтактнаяИнформация) Экспорт	
	
КонецПроцедуры

#КонецОбласти

#Область СведенияОбУполномоченномПредставителе

// Переопределяет структуру, содержащую сведения о регистрационных данных уполномоченного представителя.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные - Структура -
//                  см. ОрганизацииСервер.РегистрационныеДанныеУполномоченногоПредставителя.
Процедура ПриОпределенииРегистрационныхДанныхУполномоченногоПредставителя(Организация, Поля, Дата, РегистрационныеДанные) Экспорт
			
КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации уполномоченного представителя.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата, Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - Структура -
//                  см. ОрганизацииСервер.КонтактнаяИнформацияУполномоченногоПредставителя.
Процедура ПриОпределенииКонтактнойИнформацииУполномоченногоПредставителя(Организация, Поля, Дата, КонтактнаяИнформация) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти