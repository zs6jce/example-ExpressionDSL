package org.xtext.example.expressiondsl.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import org.xtext.example.expressiondsl.expressionDSL.Model
import org.xtext.example.expressiondsl.expressionDSL.VariableAssignment

import org.xtext.example.expressiondsl.tests.TestUtils

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
		var actual = TestUtils.stringRepr(stmt.exp)
		Assertions.assertEquals(expected, actual)
	}

}
