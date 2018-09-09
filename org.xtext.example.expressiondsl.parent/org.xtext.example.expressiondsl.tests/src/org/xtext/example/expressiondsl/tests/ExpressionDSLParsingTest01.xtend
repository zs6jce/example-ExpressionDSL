package org.xtext.example.expressiondsl.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.xtext.example.expressiondsl.expressionDSL.FunctionDef
import org.xtext.example.expressiondsl.expressionDSL.IntConstant
import org.xtext.example.expressiondsl.expressionDSL.Model
import org.xtext.example.expressiondsl.expressionDSL.QualifiedRef
import org.xtext.example.expressiondsl.expressionDSL.StructDef
import org.xtext.example.expressiondsl.expressionDSL.SubFieldDef
import org.xtext.example.expressiondsl.expressionDSL.VariableAssignment
import org.xtext.example.expressiondsl.expressionDSL.VariableDef
import org.xtext.example.expressiondsl.expressionDSL.VariableOrArrayOrFunc

@RunWith(XtextRunner)
@InjectWith(ExpressionDSLInjectorProvider)
class ExpressionDSLParsingTest01 {
	@Inject
	ParseHelper<Model> parseHelper
	
	@Test
	def void test01() {
	
		var String actualPrecedence = null

		val result = parseHelper.parse('''
			var int intA;
			var int intB dim(10);

			struct structA;
				subf int subfA;
			endstruct;

			struct structB dim(10);
				subf int subfB;
			endstruct;

			struct structC dim(10);
				subf int subfC dim(20);
				struct subStructC dim(30);
					subf int subSubfC dim(40);
				endstruct;
			endstruct;

			def char funcTest;

			// Normal Assignment
			intA = intB;

			// Assign result of function
			intA = funcTest();
			intA = funcTest(1); 
			intA = funcTest(2:3);
			intA = funcTest(intA);
			
			// Arrays
			intA = intB(4);
			intA = intB(funcTest(5));
			intA = intB(intA);

			// Qualified
			intA = structA;
			intA = structA.subfA;

			intA = structB(5);
			intA = structB(funcTest());

			intA = structB(6).subfB;

			intA = structC(7).subfC(8);
			intA = structC(9).subStructC(10).subSubfC(11);

		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)

//		var int intA;
		var intA = result.statements.get(0) as VariableDef;
		Assert.assertEquals('intA', intA.name)
		
//		var int intB dim(10);
		var intB = result.statements.get(1) as VariableDef;
		Assert.assertEquals('intB', intB.name)

//		struct structA;
//			subf int subfA;
//		endstruct;
		var structA = result.statements.get(2) as StructDef;
		var subfA = structA.subFields.get(0) as SubFieldDef;
		Assert.assertEquals('structA', structA.name)
		Assert.assertEquals('subfA', subfA.name)

//		struct structB dim(10);
//			subf int subfB;
//		endstruct;
		var structB = result.statements.get(3) as StructDef;
		var subfB = structB.subFields.get(0) as SubFieldDef;
		Assert.assertEquals('structB', structB.name)
		Assert.assertEquals('subfB', subfB.name)

//		struct structC dim(10);
//			subf int subfC dim(20);
//			struct subStructC dim(30);
//				subf int subSubfC dim(40);
//			endstruct;
//		endstruct;
		var structC = result.statements.get(4) as StructDef;
		var subfC = structC.subFields.get(0) as SubFieldDef;
		var subStructC = structC.subFields.get(1) as StructDef;
		var subSubfC = subStructC.subFields.get(0) as SubFieldDef;
		Assert.assertEquals('structC', structC.name)
		Assert.assertEquals('subfC', subfC.name)
		Assert.assertEquals('subStructC', subStructC.name)
		Assert.assertEquals('subSubfC', subSubfC.name)

//		def char funcTest;
		var funcTest = result.statements.get(5) as FunctionDef;
		Assert.assertEquals('funcTest', funcTest.name)

//		intA = intB;
		var VarAssignment01 = result.statements.get(6) as VariableAssignment;
		var tgtvar01 = VarAssignment01.tgtvar as VariableDef;		
		var exp01 = VarAssignment01.exp as VariableOrArrayOrFunc;
		var ref01 = exp01.ref as VariableDef;
		Assert.assertEquals('intA', tgtvar01.name)
		Assert.assertEquals('intB', ref01.name)
		actualPrecedence = TestUtils.stringRepr(exp01)
		Assert.assertEquals('intB', actualPrecedence)

//		intA = funcTest();
		var VarAssignment02 = result.statements.get(7) as VariableAssignment;
		var tgtvar02 = VarAssignment02.tgtvar as VariableDef;
		var exp02 = VarAssignment02.exp as VariableOrArrayOrFunc;
		var ref02 = exp02.ref as FunctionDef;
		Assert.assertEquals('intA', tgtvar02.name)
		Assert.assertEquals('funcTest', ref02.name)
		actualPrecedence = TestUtils.stringRepr(exp02)
		Assert.assertEquals('funcTest()', actualPrecedence)

//		intA = funcTest(1);
		var VarAssignment03 = result.statements.get(8) as VariableAssignment;
		var tgtvar03 = VarAssignment03.tgtvar as VariableDef;
		var exp03 = VarAssignment03.exp as VariableOrArrayOrFunc;
		var ref03 = exp03.ref as FunctionDef;
		var parm03A = exp03.params.head as IntConstant
		Assert.assertEquals('intA', tgtvar03.name)
		Assert.assertEquals('funcTest', ref03.name)
		Assert.assertEquals(1, exp03.params.length)
		Assert.assertEquals(1, parm03A.value)
		actualPrecedence = TestUtils.stringRepr(exp03)
		Assert.assertEquals('funcTest(1)', actualPrecedence)

//		intA = funcTest(2:3);
		var VarAssignment04 = result.statements.get(9) as VariableAssignment;
		var tgtvar04 = VarAssignment04.tgtvar as VariableDef;
		var exp04 = VarAssignment04.exp as VariableOrArrayOrFunc;
		var ref04 = exp04.ref as FunctionDef;
		var parm04A = exp04.params.get(0) as IntConstant
		var parm04B = exp04.params.get(1) as IntConstant
		Assert.assertEquals('intA', tgtvar04.name)
		Assert.assertEquals('funcTest', ref04.name)
		Assert.assertEquals(2, exp04.params.length)
		Assert.assertEquals(2, parm04A.value)
		Assert.assertEquals(3, parm04B.value)
		actualPrecedence = TestUtils.stringRepr(exp04)
		Assert.assertEquals('funcTest(2:3)', actualPrecedence)

//		intA = funcTest(intA);
		var VarAssignment08 = result.statements.get(10) as VariableAssignment;
		var tgtvar08 = VarAssignment08.tgtvar as VariableDef; //intA
		var exp08 = VarAssignment08.exp as VariableOrArrayOrFunc; //funcTest(intA)
		var ref08 = exp08.ref as FunctionDef // funcTest
		var parm08A = exp08.params.get(0) as VariableOrArrayOrFunc // intA
		var ref09 = parm08A.ref as VariableDef;
		Assert.assertEquals('intA', tgtvar08.name)
		Assert.assertEquals('funcTest', ref08.name)
		Assert.assertEquals(1, exp08.params.length)
		Assert.assertEquals('intA', ref09.name)
		actualPrecedence = TestUtils.stringRepr(exp08)
		Assert.assertEquals('funcTest(intA)', actualPrecedence)

//		intA = intB(4);
		var VarAssignment05 = result.statements.get(11) as VariableAssignment;
		var tgtvar05 = VarAssignment05.tgtvar as VariableDef;
		var exp05 = VarAssignment05.exp as VariableOrArrayOrFunc;
		var ref05 = exp05.ref as VariableDef;
		var parm05A = exp05.params.get(0) as IntConstant
		Assert.assertEquals('intA', tgtvar05.name)
		Assert.assertEquals('intB', ref05.name)
		Assert.assertEquals(1, exp05.params.length)
		Assert.assertEquals(4, parm05A.value)
		actualPrecedence = TestUtils.stringRepr(exp05)
		Assert.assertEquals('intB(4)', actualPrecedence)

//		intA = intB(funcTest(5));
		var VarAssignment06 = result.statements.get(12) as VariableAssignment;
		var tgtvar06 = VarAssignment06.tgtvar as VariableDef; //intA
		var exp06 = VarAssignment06.exp as VariableOrArrayOrFunc; //intB(funcTest(5))
		var ref06 = exp06.ref as VariableDef; //intB
		var parm06A = exp06.params.get(0) as VariableOrArrayOrFunc // funcTest(5)
		var ref07 = parm06A.ref as FunctionDef // funcTest
		var param07A = parm06A.params.get(0) as IntConstant
		Assert.assertEquals('intA', tgtvar06.name)
		Assert.assertEquals('intB', ref06.name)
		Assert.assertEquals(1, exp06.params.length)
		Assert.assertEquals('funcTest', ref07.name)
		Assert.assertEquals(1, parm06A.params.length)
		Assert.assertEquals(5, param07A.value)
		actualPrecedence = TestUtils.stringRepr(exp06)
		Assert.assertEquals('intB(funcTest(5))', actualPrecedence)

//		intA = intB(intA);
		var VarAssignment10 = result.statements.get(13) as VariableAssignment;
		var tgtvar10 = VarAssignment10.tgtvar as VariableDef; //intA
		var exp10 = VarAssignment10.exp as VariableOrArrayOrFunc; //intB(intA)
		var ref10 = exp10.ref as VariableDef // intB
		var parm10A = exp10.params.get(0) as VariableOrArrayOrFunc // intA
		var ref11 = parm10A.ref as VariableDef;
		Assert.assertEquals('intA', tgtvar10.name)
		Assert.assertEquals('intB', ref10.name)
		Assert.assertEquals(1, exp10.params.length)
		Assert.assertEquals('intA', ref11.name)

//		intA = structA;
		var VarAssignment12 = result.statements.get(14) as VariableAssignment;
		var tgtvar12 = VarAssignment12.tgtvar as VariableDef;
		var exp12 = VarAssignment12.exp as VariableOrArrayOrFunc;
		var ref12 = exp12.ref as StructDef;
		Assert.assertEquals('intA', tgtvar12.name)
		Assert.assertEquals('structA', ref12.name)

//		intA = structA.subfA;
		var VarAssignment13 = result.statements.get(15) as VariableAssignment;
		var tgtvar13 = VarAssignment13.tgtvar as VariableDef;
		var exp13 = VarAssignment13.exp as QualifiedRef;
		var head13 = exp13.head as VariableOrArrayOrFunc;
		var head13ref = head13.ref as StructDef
		var tail13 = exp13.tail as VariableOrArrayOrFunc;
		var tail13ref = tail13.ref as SubFieldDef // <<< Can't Cast Named to SubFieldDef <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		Assert.assertEquals('intA', tgtvar13.name)
		Assert.assertEquals('structA', head13ref.name)
//>>>	Assert.assertEquals('subfA', tail13ref.name) <<<

//		intA = structB(5);
		var VarAssignment14 = result.statements.get(16) as VariableAssignment;
		var tgtvar14 = VarAssignment14.tgtvar as VariableDef;
		var exp14 = VarAssignment14.exp as VariableOrArrayOrFunc;
		var ref14 = exp14.ref as StructDef;
		var param14A = exp14.params.get(0) as IntConstant
		Assert.assertEquals('intA', tgtvar14.name)
		Assert.assertEquals('structB', ref14.name)
		Assert.assertEquals(1, exp14.params.length)
		Assert.assertEquals(5, param14A.value)

//		intA = structB(funcTest());
		var VarAssignment15 = result.statements.get(17) as VariableAssignment;
		var tgtvar15 = VarAssignment15.tgtvar as VariableDef;
		var exp15 = VarAssignment15.exp as VariableOrArrayOrFunc;
		var ref15 = exp15.ref as StructDef;
		var param15A = exp15.params.get(0) as VariableOrArrayOrFunc
		var param15Aref = param15A.ref as FunctionDef
		Assert.assertEquals('intA', tgtvar15.name)
		Assert.assertEquals('structB', ref15.name)
		Assert.assertEquals(1, exp15.params.length)
		Assert.assertEquals('funcTest', param15Aref.name)

//		intA = structB(6).subfB;
		var VarAssignment16 = result.statements.get(18) as VariableAssignment;
		var tgtvar16 = VarAssignment16.tgtvar as VariableDef;
		var exp16 = VarAssignment16.exp as QualifiedRef;
		var head16 = exp16.head as VariableOrArrayOrFunc;
		var head16ref = head16.ref as StructDef
		var head16paramA = head16.params.get(0) as IntConstant
		var tail16 = exp16.tail as VariableOrArrayOrFunc;
//>>>	var tail16ref = tail16.ref as SubFieldDef; <<<
		Assert.assertEquals('intA', tgtvar16.name)
		Assert.assertEquals('structB', head16ref.name)
		Assert.assertEquals(1, head16.params.length)
		Assert.assertEquals(6, head16paramA.value)
//>>>	Assert.assertEquals('subfB', tail16ref.name) <<<

//		intA = structC(7).subfC(8);
		var VarAssignment17 = result.statements.get(19) as VariableAssignment;
		var tgtvar17 = VarAssignment17.tgtvar as VariableDef;
		var exp17 = VarAssignment17.exp as QualifiedRef;
		var head17 = exp17.head as VariableOrArrayOrFunc;
		var head17ref = head17.ref as StructDef
		var head17paramA = head17.params.get(0) as IntConstant
		var tail17 = exp17.tail as VariableOrArrayOrFunc;
//>>>	var tail17ref = tail17.ref as SubFieldDef <<<
		var tail17paramA = tail17.params.get(0) as IntConstant
		Assert.assertEquals('intA', tgtvar17.name)
		Assert.assertEquals('structC', head17ref.name)
		Assert.assertEquals(1, head17.params.length)
		Assert.assertEquals(7, head17paramA.value)
//>>>	Assert.assertEquals('subfC', tail17ref.name) <<<
		Assert.assertEquals(1, tail17.params.length)
		Assert.assertEquals(8, tail17paramA.value)

//		intA = structC(9).subStructC(10).subSubfC(11);
		var VarAssignment18 = result.statements.get(20) as VariableAssignment
		var tgtvar18 = VarAssignment18.tgtvar as VariableDef //intA
		var exp18 = VarAssignment18.exp as QualifiedRef // structC(9).subStructC(10).subSubfC(11);
		
		var head18 = exp18.head as QualifiedRef
		var head18head18 = head18.head as VariableOrArrayOrFunc
		var head18head18ref = head18head18.ref as StructDef //structC
		var head18head18paramA = head18head18.params.get(0) as IntConstant //(9)

		var tail18 = exp18.tail as VariableOrArrayOrFunc
//		var tail18ref = tail18.ref as StructDef //subStructC <<<
		var tail18paramA = tail18.params.get(0) as IntConstant //(10)
//		var tail18 = exp18.tail as QualifiedRef; // subStructC(10).subSubfC(11);		
//		var head18ref = head18.ref as StructDef 
//		var tail18head18ref = tail18head18.ref as StructDef //structC
//		var tail18head18paramA = tail18head18.params.get(0) as IntConstant //(10)
//		
////		var tail18paramA = tail18.params.get(0) as IntConstant
//
////		//TODO 'subSubfC'
////		//TODO 11 from subSubfC(11)

		Assert.assertEquals('intA', tgtvar18.name)
		Assert.assertEquals('structC', head18head18ref.name)
		Assert.assertEquals(1, head18head18.params.length)
		Assert.assertEquals(9, head18head18paramA.value)
//>>>	AssertEquals('subStructC', tailref.name)
		Assert.assertEquals(1, tail18.params.length)
//		Assert.assertEquals(10, tail18paramA.value)
////		AssertEquals('subSubfC', .name) <<<
////		Assert.assertEquals(1, .params.length)
////		Assert.assertEquals(11, .value)

		val errorsFinal = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errorsFinal.join(", ")»''', errorsFinal.isEmpty)
	}

}