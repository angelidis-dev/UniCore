// Android Example - Kotlin
// Comprehensive Password Validation with Strength Indicator

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewmodel.compose.viewModel

// Swift SDK Import (simulated)
// import UniCoreValidation

/**
 * Password Validation ViewModel
 * 
 * Demonstrates password strength calculation and validation
 * using UniCoreValidation Swift package via Android SDK
 */
class PasswordValidationViewModel : ViewModel() {
    val password = mutableStateOf("")
    val confirmPassword = mutableStateOf("")
    
    val passwordErrors = mutableStateOf<List<ValidationErrorModel>>(emptyList())
    val confirmErrors = mutableStateOf<List<ValidationErrorModel>>(emptyList())
    
    val isPasswordValid = mutableStateOf(false)
    val isConfirmValid = mutableStateOf(false)
    val passwordStrength = mutableStateOf(PasswordStrength.WEAK)
    
    fun validatePassword(input: String) {
        password.value = input
        
        // Swift validation call
        val result = validatePasswordSwift(input)
        isPasswordValid.value = result.isValid
        passwordErrors.value = result.errors ?: emptyList()
        
        updatePasswordStrength()
    }
    
    fun validateConfirmPassword(input: String) {
        confirmPassword.value = input
        
        // Confirm password matches
        val result = when {
            input.isEmpty() -> ValidationResultModel(
                isValid = false,
                errors = listOf(
                    ValidationErrorModel(
                        code = "required",
                        messageKey = "validation.required",
                        metadata = emptyMap()
                    )
                )
            )
            input != password.value -> ValidationResultModel(
                isValid = false,
                errors = listOf(
                    ValidationErrorModel(
                        code = "equals",
                        messageKey = "validation.equals",
                        metadata = emptyMap()
                    )
                )
            )
            else -> ValidationResultModel(isValid = true, errors = null)
        }
        
        isConfirmValid.value = result.isValid
        confirmErrors.value = result.errors ?: emptyList()
    }
    
    private fun validatePasswordSwift(input: String): ValidationResultModel {
        val errors = mutableListOf<ValidationErrorModel>()
        
        if (input.isEmpty()) {
            errors.add(
                ValidationErrorModel(
                    code = "required",
                    messageKey = "validation.required",
                    metadata = emptyMap()
                )
            )
        }
        
        if (input.length < 8) {
            errors.add(
                ValidationErrorModel(
                    code = "minLength",
                    messageKey = "validation.minLength",
                    metadata = mapOf(
                        "minLength" to "8",
                        "currentLength" to input.length.toString()
                    )
                )
            )
        }
        
        if (input.length > 128) {
            errors.add(
                ValidationErrorModel(
                    code = "maxLength",
                    messageKey = "validation.maxLength",
                    metadata = mapOf(
                        "maxLength" to "128",
                        "currentLength" to input.length.toString()
                    )
                )
            )
        }
        
        val hasUpperAndLower = 
            input.any { it.isUpperCase() } && input.any { it.isLowerCase() }
        val hasDigit = input.any { it.isDigit() }
        
        if (!hasUpperAndLower || !hasDigit) {
            errors.add(
                ValidationErrorModel(
                    code = "password.weak",
                    messageKey = "validation.password.requiresUpperLowerNumber",
                    metadata = emptyMap()
                )
            )
        }
        
        return if (errors.isEmpty()) {
            ValidationResultModel(isValid = true, errors = null)
        } else {
            ValidationResultModel(isValid = false, errors = errors)
        }
    }
    
    private fun updatePasswordStrength() {
        val pwd = password.value
        var score = 0
        
        if (pwd.length >= 8) score++
        if (pwd.length >= 12) score++
        
        if (pwd.any { it.isLowerCase() }) score++
        if (pwd.any { it.isUpperCase() }) score++
        if (pwd.any { it.isDigit() }) score++
        if (pwd.any { !it.isLetterOrDigit() }) score++
        
        passwordStrength.value = when (score) {
            in 0..2 -> PasswordStrength.WEAK
            3 -> PasswordStrength.FAIR
            4 -> PasswordStrength.GOOD
            else -> PasswordStrength.STRONG
        }
    }
    
    val allValid: Boolean
        get() = isPasswordValid.value && isConfirmValid.value && 
                passwordStrength.value == PasswordStrength.STRONG
}

enum class PasswordStrength {
    WEAK, FAIR, GOOD, STRONG;
    
    val color: Color
        get() = when (this) {
            WEAK -> Color(0xFFC62828)
            FAIR -> Color(0xFFF57C00)
            GOOD -> Color(0xFFF9A825)
            STRONG -> Color(0xFF2E7D32)
        }
    
    val label: String
        get() = when (this) {
            WEAK -> "Weak"
            FAIR -> "Fair"
            GOOD -> "Good"
            STRONG -> "Strong"
        }
}

// Password Requirements Checker Composable
@Composable
fun PasswordRequirementsChecker(password: String) {
    val hasMinLength = password.length >= 8
    val hasMaxLength = password.length <= 128
    val hasUppercase = password.any { it.isUpperCase() }
    val hasLowercase = password.any { it.isLowerCase() }
    val hasNumbers = password.any { it.isDigit() }
    
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 12.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        )
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(12.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                "Requirements",
                style = MaterialTheme.typography.labelSmall,
                modifier = Modifier.padding(bottom = 4.dp)
            )
            
            PasswordRequirementRow("At least 8 characters", hasMinLength)
            PasswordRequirementRow("At most 128 characters", hasMaxLength)
            PasswordRequirementRow("At least one uppercase letter (A-Z)", hasUppercase)
            PasswordRequirementRow("At least one lowercase letter (a-z)", hasLowercase)
            PasswordRequirementRow("At least one number (0-9)", hasNumbers)
        }
    }
}

@Composable
fun PasswordRequirementRow(text: String, met: Boolean) {
    Row(
        modifier = Modifier
            .fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = if (met) Icons.Default.CheckCircle else Icons.Default.Circle,
            contentDescription = null,
            tint = if (met) Color.Green else Color.Gray,
            modifier = Modifier.size(16.dp)
        )
        
        Text(
            text,
            style = MaterialTheme.typography.bodySmall,
            color = if (met) MaterialTheme.colorScheme.onSurface else 
                    MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

// Main Password Validation Screen
@Composable
fun PasswordValidationDemoScreen(
    viewModel: PasswordValidationViewModel = viewModel()
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(20.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Text(
            "Password Validation Demo",
            style = MaterialTheme.typography.headlineSmall
        )
        
        Text(
            "Create a strong password with real-time validation",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        
        // Password Input with Strength Indicator
        Card(
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        "Password",
                        style = MaterialTheme.typography.labelLarge
                    )
                    
                    Row(
                        horizontalArrangement = Arrangement.spacedBy(4.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            viewModel.passwordStrength.value.label,
                            style = MaterialTheme.typography.labelSmall,
                            color = viewModel.passwordStrength.value.color
                        )
                        
                        Box(
                            modifier = Modifier
                                .size(8.dp)
                                .background(
                                    color = viewModel.passwordStrength.value.color,
                                    shape = MaterialTheme.shapes.small
                                )
                        )
                    }
                }
                
                OutlinedTextField(
                    value = viewModel.password.value,
                    onValueChange = { viewModel.validatePassword(it) },
                    label = { Text("Enter password") },
                    modifier = Modifier.fillMaxWidth(),
                    visualTransformation = PasswordVisualTransformation()
                )
            }
        }
        
        // Requirements
        PasswordRequirementsChecker(viewModel.password.value)
        
        // Password Errors
        if (viewModel.passwordErrors.value.isNotEmpty()) {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                viewModel.passwordErrors.value.forEach { error ->
                    Card(
                        modifier = Modifier.fillMaxWidth(),
                        colors = CardDefaults.cardColors(
                            containerColor = Color(0xFFFFEBEE)
                        )
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(12.dp),
                            horizontalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            Icon(
                                Icons.Default.Error,
                                contentDescription = null,
                                tint = Color(0xFFC62828),
                                modifier = Modifier.size(20.dp)
                            )
                            
                            Column {
                                Text(
                                    error.messageKey,
                                    style = MaterialTheme.typography.bodySmall,
                                    color = Color(0xFFC62828)
                                )
                                if (error.metadata.isNotEmpty()) {
                                    Text(
                                        error.metadata.map { "${it.key}: ${it.value}" }.joinToString(" • "),
                                        style = MaterialTheme.typography.bodySmall,
                                        color = Color.Gray
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Confirm Password
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        "Confirm Password",
                        style = MaterialTheme.typography.labelLarge
                    )
                    
                    if (viewModel.isConfirmValid.value) {
                        Icon(
                            Icons.Default.CheckCircle,
                            contentDescription = "Valid",
                            tint = Color.Green
                        )
                    }
                }
                
                OutlinedTextField(
                    value = viewModel.confirmPassword.value,
                    onValueChange = { viewModel.validateConfirmPassword(it) },
                    label = { Text("Re-enter password") },
                    modifier = Modifier.fillMaxWidth(),
                    visualTransformation = PasswordVisualTransformation()
                )
            }
        }
        
        // Confirm Errors
        if (viewModel.confirmErrors.value.isNotEmpty()) {
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(
                    containerColor = Color(0xFFFFEBEE)
                )
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(12.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Icon(
                        Icons.Default.Error,
                        contentDescription = null,
                        tint = Color(0xFFC62828)
                    )
                    
                    Text(
                        viewModel.confirmErrors.value.first().messageKey,
                        style = MaterialTheme.typography.bodySmall
                    )
                }
            }
        }
        
        // Submit Button
        Button(
            onClick = { },
            modifier = Modifier
                .fillMaxWidth()
                .height(48.dp),
            enabled = viewModel.allValid
        ) {
            Text("Create Account")
        }
        
        Spacer(modifier = Modifier.height(20.dp))
    }
}
