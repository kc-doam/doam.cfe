﻿
////////////////////////////////////////////////////////////////////////////////
// Работа с программой
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет, нужно ли открывать форму вопроса при завершении программы
//
// Возвращаемое значение:
//   - Булево - принимает значение Истина, если нужно открыть форму при завершении программы,
//              иначе Ложь.
//
Функция ОткрытьФормуВопросаПриЗавершенииПрограммы() Экспорт
	
	ЗапрашиватьПодтверждениеПриЗакрытииПрограммы =
		РаботаСПрограммой.ПолучитьЗапросРазрешенияНаВыходИзПрограммы();
		
	Если НЕ ЗначениеЗаполнено(ЗапрашиватьПодтверждениеПриЗакрытииПрограммы) Тогда
		ЗапрашиватьПодтверждениеПриЗакрытииПрограммы = Ложь;
	КонецЕсли;
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", "ПоказыватьЗанятыеФайлыПриЗавершенииРаботы", Истина);
		
	ЕстьЗанятыеФайлы = Ложь;
	
	Если ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = Истина Тогда
		ТекущийПользователь = Пользователи.ТекущийПользователь();
		КоличествоЗанятыхФайлов =
			РаботаСФайламиВызовСервера.ПолучитьКоличествоЗанятыхФайлов(Неопределено, ТекущийПользователь, Истина);
		Если КоличествоЗанятыхФайлов > 0 Тогда
			ЕстьЗанятыеФайлы = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФормуВопроса = ЗапрашиватьПодтверждениеПриЗакрытииПрограммы
		ИЛИ ЕстьЗанятыеФайлы;
		
	Возврат ОткрытьФормуВопроса;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьЗапросРазрешенияНаВыходИзПрограммы() Экспорт
	
	Возврат ХранилищеОбщихНастроек.Загрузить("НастройкаВыходаИзПрограммы");
	
КонецФункции

#КонецОбласти

