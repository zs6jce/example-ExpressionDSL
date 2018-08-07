package org.xtext.example.expressiondsl.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static extension org.junit.Assert.*
import org.xtext.example.expressiondsl.expressionDSL.Model
import org.xtext.example.expressiondsl.expressionDSL.VariableAssignment
import org.xtext.example.expressiondsl.expressionDSL.Expression
import org.xtext.example.expressiondsl.expressionDSL.BinaryPlus
//import org.xtext.example.expressiondsl.expressionDSL.UnaryPlus
import org.xtext.example.expressiondsl.expressionDSL.BinaryMinus
//import org.xtext.example.expressiondsl.expressionDSL.UnaryMinus
import org.xtext.example.expressiondsl.expressionDSL.MulOrDiv
import org.xtext.example.expressiondsl.expressionDSL.Exponent
import org.xtext.example.expressiondsl.expressionDSL.And
import org.xtext.example.expressiondsl.expressionDSL.Or
//import org.xtext.example.expressiondsl.expressionDSL.Not
import org.xtext.example.expressiondsl.expressionDSL.IntConstant
import org.xtext.example.expressiondsl.expressionDSL.BooleanConstant
import org.xtext.example.expressiondsl.expressionDSL.Comparison
import org.xtext.example.expressiondsl.expressionDSL.UnaryPlus
import org.xtext.example.expressiondsl.expressionDSL.UnaryMinus
import org.xtext.example.expressiondsl.expressionDSL.Not
import org.xtext.example.expressiondsl.expressionDSL.FunctionExp
import org.xtext.example.expressiondsl.expressionDSL.FunctionDef
import org.xtext.example.expressiondsl.expressionDSL.VariableOrConstDef
import org.xtext.example.expressiondsl.expressionDSL.VariableDef
import org.xtext.example.expressiondsl.expressionDSL.ConstDef
import org.xtext.example.expressiondsl.expressionDSL.VariableOrConstRef

@ExtendWith(InjectionExtension)
@InjectWith(ExpressionDSLInjectorProvider)
class ExpressionDSLPrecedenceTest {
	@Inject	extension ParseHelper<Model>

	@Test def void testIntConstant() {
		"10".assertRepr("10")
	}

	@Test def void testBoolConstant() {
		"true".assertRepr("true")
		"false".assertRepr("false")
	}

	@Test def void testBinaryPlus() {
		"10 + 5 + 1 + 2".assertRepr("(((10 + 5) + 1) + 2)")
	}

	@Test def void testUnaryPlus() {
		"+10 + +5 + +1 + +2".assertRepr("(((( +10) + ( +5)) + ( +1)) + ( +2))")
	}

	@Test def void testPlusWithParenthesis() {
		"( 10 + 5 ) + ( 1 + 2 )".assertRepr("((10 + 5) + (1 + 2))")
	}

	@Test
	def void testBinaryMinus() {
		"10 + 5 - 1 - 2".assertRepr("(((10 + 5) - 1) - 2)")
	}

	@Test def void testUnaryMinus() {
		"-10 + -5 - -1 - -2".assertRepr("(((( -10) + ( -5)) - ( -1)) - ( -2))")
	}

	@Test
	def void testMulOrDiv() {
		"10 * 5 / 1 * 2".assertRepr("(((10 * 5) / 1) * 2)")
	}

	@Test
	def void testPlusMulPrecedence() {
		"10 + 5 * 2 - 5 / 1".assertRepr("((10 + (5 * 2)) - (5 / 1))")
	}

	@Test def void testComparison() {
		"1 <= 2 < 3 > 4".assertRepr("(((1 <= 2) < 3) > 4)")
	}

	@Test def void testEqualityAndComparison() {
		"true = 5 <= 2".assertRepr("((true = 5) <= 2)")		// Type computer should have error on <=
		"true = (5 <= 2)".assertRepr("(true = (5 <= 2))")	// No Error Expected
	}

	@Test def void testAndOr() {
		"true OR false AND 1 < 0".assertRepr("(true OR (false AND (1 < 0)))")
	}

	@Test def void testNot() {
		"true OR false".assertRepr("(true OR false)")
		"NOT true OR false".assertRepr("((NOT true) OR false)")
	}

	@Test def void testNotWithParentheses() {
		"NOT(true OR false)".assertRepr("(NOT (true OR false))")
	}

	@Test def void testPrecedences() {
		"NOT true OR false AND 1>(1/3+5*2)".
		assertRepr("((NOT true) OR (false AND (1 > ((1 / 3) + (5 * 2)))))")
	}

	@Test def void testExponentiation01() {
		"1**2**3".assertRepr("(1 ** (2 ** 3))") // Precedence is important
	}

	@Test def void testExponentiation02() {
		"1**2**-3".assertRepr("(1 ** (2 ** ( -3)))")
	}

	@Test def void testNestedAssignment() {
		"1 = 2 = 3 = 4 = (5 = 6)".assertRepr("((((1 = 2) = 3) = 4) = (5 = 6))")
	}

	@Test def void testFunction01() {
		"TstDef01()".assertRepr("TstDef01()")
	}

	@Test def void testFunction02() {
		"TstDef01(1)".assertRepr("TstDef01(1)")
	}
	@Test def void testFunction03() {
		"TstDef01(TstVar01)".assertRepr("TstDef01(TstVar01)")
	}

	@Test def void testFunction04() {
		"TstDef01(TstVar01:2)".assertRepr("TstDef01(TstVar01:2)")
	}

	@Test def void testFunction05() {
		"TstDef01(TstVar01:TstDef02():2)".assertRepr("TstDef01(TstVar01:TstDef02():2)")
	}

	@Test def void testFunction06() {
		"TstDef01(TstVar01:TstDef02(TstVal02):2)".assertRepr("TstDef01(TstVar01:TstDef02(TstVal02):2)")
	}
	
	def private assertRepr(CharSequence input, CharSequence expected) {
		var result = '''
						def char TstDef01;
						def char TstDef02;

						var int TstVar01;
						var int TstVar02;

						val bool TstVal01;
						val bool TstVal02;

						TstVar01 = «input»
		'''.parse
		var stmt = result.statements.last as VariableAssignment
		var actual = stringRepr(stmt.exp)
		assertEquals(expected, actual)
	}

	def private String stringRepr(Expression e) {
		switch (e) {

			And	: '''(«e.left.stringRepr» AND «e.right.stringRepr»)'''
			Or	: '''(«e.left.stringRepr» OR «e.right.stringRepr»)'''

			Comparison: '''(«e.left.stringRepr» «e.op» «e.right.stringRepr»)'''

			BinaryPlus: '''(«e.left.stringRepr» + «e.right.stringRepr»)'''
			BinaryMinus: '''(«e.left.stringRepr» - «e.right.stringRepr»)'''

			MulOrDiv: '''(«e.left.stringRepr» «e.op» «e.right.stringRepr»)'''

			Exponent: '''(«e.left.stringRepr» ** «e.right.stringRepr»)'''

			FunctionExp : '''«e.func.name.name»(«FOR param: e.func.params SEPARATOR ':'»«param.stringRepr»«ENDFOR»)'''

			UnaryPlus: '''( +«e.expr.stringRepr»)'''
			UnaryMinus: '''( -«e.expr.stringRepr»)'''			
			Not: '''(NOT «e.expr.stringRepr»)'''

			VariableOrConstRef: '''«e.value.stringRepr»'''
			IntConstant: '''«e.value»'''
			BooleanConstant: '''«e.value»'''
		}.toString
	}

	def private String stringRepr(VariableOrConstDef e) {
		switch (e) {
			VariableDef: e.name
			ConstDef: e.name
		}
	}
}
