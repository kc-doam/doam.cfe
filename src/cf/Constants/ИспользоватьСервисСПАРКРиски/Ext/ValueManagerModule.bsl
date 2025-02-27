﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьСервис = Значение;
	
	РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ВсеОбновленияСПАРКРискиОбщее,
		ИспользоватьСервис);
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		// Отключается только при работе в локальном режиме.
		// При работе в модели сервиса не отключается,
		// т.к. требуется отключение в каждой области данных при
		// неограниченном количестве областей. В этом случае выполняется проверка
		// внутри регламентного задания.
		РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
			Метаданные.РегламентныеЗадания.ВсеОбновленияСПАРКРискиРазделенное,
			ИспользоватьСервис);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли