/*
 * generated by Xtext 2.14.0
 */
package org.xtext.example.expressiondsl.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.xtext.example.expressiondsl.expressionDSL.Model

@RunWith(XtextRunner)
@InjectWith(ExpressionDSLInjectorProvider)
class ExpressionDSLParsingTest {
	@Inject
	ParseHelper<Model> parseHelper
	
//	@Test
//	def void loadModel() {
//		val result = parseHelper.parse('''
//			Hello Xtext!
//		''')
//		Assert.assertNotNull(result)
//		val errors = result.eResource.errors
//		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
//	}

	@Test
	def void testDeclarations() {
		val result = parseHelper.parse('''
			var bool bA;
			var char cA;
			var int  iA;
			
			val bool vbA;
			val char vcA;
			var int  ciA;
			
			def bool funcBool;
			def char funcChar;
			def int  funcInt;
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
	}

	@Test
	def void testFuncationCall01() {
		val result = parseHelper.parse('''
			def char testFunc;
			testFunc();
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
	}
	
	@Test
	def void testAssignment01() {
		val result = parseHelper.parse('''
		// Simple Assignments
			var int iA;
			var int iB;
			var char cA;
			def int testfuncNoParmsReturnsINT;

			iA   = 1;
			iA  += 1;
			iA  -= 1;
			iA  *= 1;
			iA  /= 1;
			iA **= 1;

			iA   = iB;
			iA  += iB;
			iA  -= iB;
			iA  *= iB;
			iA  /= iB;
			iA **= iB;

			cA = 'String'

			iA   = testfuncNoParmsReturnsINT();
			iA  += testfuncNoParmsReturnsINT();
			iA  -= testfuncNoParmsReturnsINT();
			iA  *= testfuncNoParmsReturnsINT();
			iA  /= testfuncNoParmsReturnsINT();
			iA **= testfuncNoParmsReturnsINT();
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
	}
	
	@Test
	def void testFuncationCall02() {
		val result = parseHelper.parse('''
			var bool bA;
			var char cA;
			var int  iA;
			
			val bool vbA;
			val char vcA;
			val int  viA;
			
			def char testFunc;
			testFunc(bA : cA : iA :
			        vbA :vcA :viA :
			        'string' : 9999
			        );
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
	}

	@Test
	def void testExpressionOr() {
		val result = parseHelper.parse('''
			var bool bA;
			var bool bB;
			var bool bC;
			
			bA = bB or bC;
			bA = bA or bB or bC;
			bA = bA or (bB or bC);
			bA = (bA or bB) or bC;
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
	}

	@Test
	def void testExpressionAnd() {
		val result = parseHelper.parse('''
			var bool bA;
			var bool bB;
			var bool bC;
			
			bA = bB and bC;
			bA = bA and bB and bC;
			bA = bA and (bB and bC);
			bA = (bA and bB) and bC;
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
	}
	
	@Test
	def void testExpressionComparison() {
		val result = parseHelper.parse('''
			var bool bA;

			var int iA;
			var int iB;
			var int iC;
			
			var int testFunc;
			
			bA = ( iA  = 1 );  // Equals
			bA = ( iA <> 1 );  // NOT Equals
			bA = ( iA >= 1 );  // Greater than or Equal
			bA = ( iA <= 1 );  // Less    than or Equal
			bA = ( iA >  1 );  // Greater than
			bA = ( iA <  1 );  // Less    than

			bA = ( iA  = iB);  // Equals
			bA = ( iA <> iB);  // NOT Equals
			bA = ( iA >= iB);  // Greater than or Equal
			bA = ( iA <= iB);  // Less    than or Equal
			bA = ( iA >  iB);  // Greater than
			bA = ( iA <  iB);  // Less    than
			
			bA = ( iA  = testFunc() );  // Equals
			bA = ( iA <> testFunc() );  // NOT Equals
			bA = ( iA >= testFunc() );  // Greater than or Equal
			bA = ( iA <= testFunc() );  // Less    than or Equal
			bA = ( iA >  testFunc() );  // Greater than
			bA = ( iA <  testFunc() );  // Less    than
			
			bA = iA = iA;
			bA = (iA = iA);
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
	}	

	@Test
	def void testExpressionBinaryPlusOrMinus() {
		//TODO
	}

	@Test
	def void testExpressionMulOrDiv() {
		//TODO
	}

	@Test
	def void testExpressionExponent() {
		//TODO
	}

	@Test
	def void testExpressionUnaryPlusOrMinus() {
		val result = parseHelper.parse('''
			var bool bA:

			var int iA;
			var int iB;
			var int iC;

			var int testFunc;

//ERROR - Type Miss match, can be flagged after parsing
«««			bA = -( iA  = 1 );  // Equals
«««			bA = -( iA <> 1 );  // NOT Equals
«««			bA = -( iA >= 1 );  // Greater than or Equal
«««			bA = -( iA <= 1 );  // Less    than or Equal
«««			bA = -( iA >  1 );  // Greater than
«««			bA = -( iA <  1 );  // Less    than
«««
«««			bA = +( iA  = 1 );  // Equals
«««			bA = +( iA <> 1 );  // NOT Equals
«««			bA = +( iA >= 1 );  // Greater than or Equal
«««			bA = +( iA <= 1 );  // Less    than or Equal
«««			bA = +( iA >  1 );  // Greater than
«««			bA = +( iA <  1 );  // Less    than

			iA = -1;
			iA = +1; // Should be flagged as Error, after parsing ?

			iA = -1 + -2;
			iA = +1 + +2; 

			iA = -iB;
			iA = +iB; // Should be flagged as Error, after parsing

«««			iA = + -iB; //ERROR
«««			iA = + +iB; //ERROR

			iA = - testFunc();
			iA = + testFunc(); // Should be flagged as Error, after parsing
			iA = - testFunc( iA : iB : testFunc() );

			iA = 1 + -testFunc();
			iA = 1 + +testFunc();
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
	}

	@Test
	def void testExpressionFunctionExp() {
		val result = parseHelper.parse('''
		var bool bA;
		var char cA;
		var int iA;
		
		def bool testFuncBool;
		def char testFuncChar;
		def int  testFuncInt;
		
		bA = testFuncBool(cA);
		bA = NOT testFuncBool(cA);
		
		cA = testFuncChar();
		
		iA = testFuncChar('String' : 77 : (88 * 99))
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
	}

	@Test
	def void testExpressionPrimary01() {
		val result = parseHelper.parse('''
			var bool bA;
			var bool bB;
			var bool bC;
			
«««			bA = bB not bC; //ERROR
«««			bA = bB not;    //ERROR

			bA = not bB;

			bA = bA or not bB and not bC;
			bA = not bA and not (bB and not bC);
			bA = (not bA or not bB) and not bC;
			
			bA = not bB = bC;
			bA = not (bB = bC);

		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
	}

	@Test
	def void testExpressionAtomic() {
		val result = parseHelper.parse('''
			var bool bA;
			var char cA;
			var int  iA;
			
			bA = true;
			bA = false;
			
			cA = 'String';
			
			iA = 11;
			iA = 0;
			iA = 01;

		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
	}

	@Test
	def void testExpressionPrecedence() {
		//TODO
	}
}

//  i = 1 + NOT + 1; //ERROR -> NOT is reserved word, not allowed to be used as Varible Name

//  i = 1 + +-+1; //ERROR - Missing Expression between "-+"
//  i = 1 + +--1; //ERROR - Missing Expression between "--"

//  testfuncReturnsINT() = i; // User-defined is NOT allowed on Left side. Aka can not be target of assignment
//  %SpecialFunc(varRef) = i; // Compiler-defined functions (Starting with %) is allowed on Left side of Assignment

//  i = 1 - +   testfuncReturnsBOOL(); // ERROR -> Type Miss Match - To be fix later with Type System
//  i = 1 - NOT testfuncReturnsBOOL(); // ERROR -> Type Miss Match - To be fix later with Type System