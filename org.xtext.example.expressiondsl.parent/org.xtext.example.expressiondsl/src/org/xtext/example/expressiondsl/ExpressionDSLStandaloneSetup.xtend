/*
 * generated by Xtext 2.14.0
 */
package org.xtext.example.expressiondsl


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class ExpressionDSLStandaloneSetup extends ExpressionDSLStandaloneSetupGenerated {

	def static void doSetup() {
		new ExpressionDSLStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
