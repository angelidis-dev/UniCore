// Android Example - Kotlin  
// Comprehensive Sign-Up Form with Full Validation

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
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewmodel.compose.viewModel

/**
 * Comprehensive Sign-Up Form ViewModel
 * 
 * Demonstrates complex form validation using UniCoreValidation
 * across multiple fields with real-time feedback
 */
class SignUpFormViewModel : ViewModel() {
    // Form fields
    val firstName = mutableStateOf("")
    val lastName = mutableStateOf("")
    val email = mutableStateOf("")
    val username = mutableStateOf("")
    val password = mutableStateOf("")
    val confirmPassword = mutableStateOf("")
    
    // Validation state
    val firstNameError = mutableStateOf<ValidationErrorModel?>(null)
    val lastNameError = mutableStateOf<ValidationErrorModel?>(null)
    val emailError = mutableStateOf<ValidationErrorModel?>(null)
    val usernameError = mutableStateOf<ValidationErrorModel?>(null)
    val passwordError = mutableStateOf<ValidationErrorModel?>(null)
    val confirmPasswordError = mutableStateOf<ValidationErrorModel?>(null)
    
    val isFirstNameValid = mutableStateOf(false)
    val isLastNameValid = mutableStateOf(false)
    val isEmailValid = mutableStateOf(false)
    val isUsernameValid = mutableStateOf(false)
    val isPasswordValid = mutableStateOf(false)
    val isConfirmPasswordValid = mutableStateOf(false)
    
    fun updateFirstName(value: String) {
        firstName.value = value
        validateFirstName()
    }
    
    fun updateLastName(value: String) {
        lastName.value = value
        validateLastName()
    }
    
    fun updateEmail(value: String) {
        email.value = value
        validateEmail()
    }
    
    fun updateUsername(value: String) {
        username.value = value
        validateUsername()
    }
    
    fun updatePassword(value: String) {
        password.value = value
        validatePassword()
    }
    
    fun updateConfirmPassword(value: String) {
        confirmPassword.value = value
        validateConfirmPassword()
    }
    
    private fun validateFirstName() {
        val result = validateTextField(firstName.value, 2, 50)
        isFirstNameValid.value = result.isValid
        firstNameError.value = result.errors?.firstOrNull()
    }
    
    private fun validateLastName() {
        val result = validateTextField(lastName.value, 2, 50)
        isLastNameValid.value = result.isValid
        lastNameError.value = result.errors?.firstOrNull()
    }
    
    private fun validateEmail() {
        val errors = mutableListOf<ValidationErrorModel>()
        
        if (email.value.isEmpty()) {
            errors.add(
                ValidationErrorModel(
                    code = "required",
                    messageKey = "validation.required",
                    metadata = emptyMap()
                )
            )
        }
        
        val emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
        if (!Regex(emailPattern).matches(email.value) && email.value.isNotEmpty()) {
            errors.add(
                ValidationErrorModel(
                    code = "email.invalid",
                    messageKey = "validation.email.invalid",
                    metadata = emptyMap()
                )
            )
        }
        
        val result = if (errors.isEmpty()) {
            ValidationResultModel(isValid = true, errors = null)
        } else {
            ValidationResultModel(isValid = false, errors = errors)
        }
        
        isEmailValid.value = result.isValid
        emailError.value = result.errors?.firstOrNull()
    }
    
    private fun validateUsername() {
        val errors = mutableListOf<ValidationErrorModel>()
        
        if (username.value.isEmpty()) {
            errors.add(
                ValidationErrorModel(
                    code = "required",
                    messageKey = "validation.required",
                    metadata = emptyMap()
                )
            )
        }
        
        if (username.value.length < 3 && username.value.isNotEmpty()) {
            errors.add(
                ValidationErrorModel(
                    code = "minLength",
                    messageKey = "validation.minLength",
                    metadata = mapOf(
                        "minLength" to "3",
                        "currentLength" to username.value.length.toString()
                    )
                )
            )
        }
        
        if (username.value.length > 20) {
            errors.add(
                ValidationErrorModel(
                    code = "maxLength",
                    messageKey = "validation.maxLength",
                    metadata = mapOf(
                        "maxLength" to "20",
                        "currentLength" to username.value.length.toString()
                    )
                )
            )
        }
        
        val validPattern = Regex("^[a-zA-Z0-9_-]+$")
        if (!validPattern.matches(username.value) && username.value.isNotEmpty()) {
            errors.add(
                ValidationErrorModel(
                    code = "username.invalid",
                    messageKey = "validation.username.alphanumericOnly",
                    metadata = emptyMap()
                )
            )
        }
        
        val result = if (errors.isEmpty()) {
            ValidationResultModel(isValid = true, errors = null)
        } else {
            ValidationResultModel(isValid = false, errors = errors)
        }
        
        isUsernameValid.value = result.isValid
        usernameError.value = result.errors?.firstOrNull()
    }
    
    private fun validatePassword() {
        val errors = mutableListOf<ValidationErrorModel>()
        
        if (password.value.isEmpty()) {
            errors.add(
                ValidationErrorModel(
                    code = "required",
                    messageKey = "validation.required",
                    metadata = emptyMap()
                )
            )
        }
        
        if (password.value.length < 8 && password.value.isNotEmpty()) {
            errors.add(
                ValidationErrorModel(
                    code = "minLength",
                    messageKey = "validation.minLength",
                    metadata = mapOf(
                        "minLength" to "8",
                        "currentLength" to password.value.length.toString()
                    )
                )
            )
        }
        
        if (password.value.length > 128) {
            errors.add(
                ValidationErrorModel(
                    code = "maxLength",
                    messageKey = "validation.maxLength",
                    metadata = emptyMap()
                )
            )
        }
        
        val hasUpperAndLower = 
            password.value.any { it.isUpperCase() } && 
            password.value.any { it.isLowerCase() }
        val hasDigit = password.value.any { it.isDigit() }
        
        if ((!hasUpperAndLower || !hasDigit) && password.value.isNotEmpty()) {
            errors.add(
                ValidationErrorModel(
                    code = "password.weak",
                    messageKey = "validation.password.requiresUpperLowerNumber",
                    metadata = emptyMap()
                )
            )
        }
        
        val result = if (errors.isEmpty()) {
            ValidationResultModel(isValid = true, errors = null)
        } else {
            ValidationResultModel(isValid = false, errors = errors)
        }
        
        isPasswordValid.value = result.isValid
        passwordError.value = result.errors?.firstOrNull()
    }
    
    private fun validateConfirmPassword() {
        val errors = mutableListOf<ValidationErrorModel>()
        
        if (confirmPassword.value.isEmpty()) {
            errors.add(
                ValidationErrorModel(
                    code = "required",
                    messageKey = "validation.required",
                    metadata = emptyMap()
                )
            )
        }
        
        if (confirmPassword.value != password.value && confirmPassword.value.isNotEmpty()) {
            errors.add(
                ValidationErrorModel(
                    code = "equals",
                    messageKey = "validation.equals",
                    metadata = emptyMap()
                )
            )
        }
        
        val result = if (errors.isEmpty()) {
            ValidationResultModel(isValid = true, errors = null)
        } else {
            ValidationResultModel(isValid = false, errors = errors)
        }
        
        isConfirmPasswordValid.value = result.isValid
        confirmPasswordError.value = result.errors?.firstOrNull()
    }
    
    private fun validateTextField(value: String, min: Int, max: Int): ValidationResultModel {
        val errors = mutableListOf<ValidationErrorModel>()
        
        if (value.isEmpty()) {
            errors.add(
                ValidationErrorModel(
                    code = "required",
                    messageKey = "validation.required",
                    metadata = emptyMap()
                )
            )
        }
        
        if (value.length < min && value.isNotEmpty()) {
            errors.add(
                ValidationErrorModel(
                    code = "minLength",
                    messageKey = "validation.minLength",
                    metadata = mapOf(
                        "minLength" to min.toString(),
                        "currentLength" to value.length.toString()
                    )
                )
            )
        }
        
        if (value.length > max) {
            errors.add(
                ValidationErrorModel(
                    code = "maxLength",
                    messageKey = "validation.maxLength",
                    metadata = mapOf(
                        "maxLength" to max.toString(),
                        "currentLength" to value.length.toString()
                    )
                )
            )
        }
        
        return if (errors.isEmpty()) {
            ValidationResultModel(isValid = true, errors = null)
        } else {
            ValidationResultModel(isValid = false, errors = errors)
        }
    }
    
    val isFormValid: Boolean
        get() = isFirstNameValid.value && isLastNameValid.value && 
                isEmailValid.value && isUsernameValid.value && 
                isPasswordValid.value && isConfirmPasswordValid.value
    
    val completionPercentage: Float
        get() {
            val validFields = listOf(
                isFirstNameValid.value, isLastNameValid.value,
                isEmailValid.value, isUsernameValid.value,
                isPasswordValid.value, isConfirmPasswordValid.value
            ).count { it }
            
            return validFields / 6f
        }
}

// Form Field Component
@Composable
fun SignUpFormField(
    label: String,
    icon: androidx.compose.material.icons.filled.Icon,
    placeholder: String,
    value: String,
    onValueChange: (String) -> Unit,
    error: ValidationErrorModel?,
    isValid: Boolean,
    isPassword: Boolean = false
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(bottom = 8.dp),
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(label, style = MaterialTheme.typography.labelLarge)
            Spacer(modifier = Modifier.weight(1f))
            if (isValid && value.isNotEmpty()) {
                Icon(
                    Icons.Default.CheckCircle,
                    contentDescription = null,
                    tint = Color.Green,
                    modifier = Modifier.size(16.dp)
                )
            }
        }
        
        OutlinedTextField(
            value = value,
            onValueChange = onValueChange,
            label = { Text(placeholder) },
            modifier = Modifier.fillMaxWidth(),
            singleLine = true
        )
        
        if (error != null && value.isNotEmpty()) {
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(
                    containerColor = Color(0xFFFFEBEE)
                )
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(8.dp)
                ) {
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

// Progress Indicator
@Composable
fun FormProgressIndicator(percentage: Float) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 12.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(
                "Form Completion",
                style = MaterialTheme.typography.labelSmall
            )
            Text(
                "${(percentage * 100).toInt()}%",
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.primary
            )
        }
        
        LinearProgressIndicator(
            progress = percentage,
            modifier = Modifier
                .fillMaxWidth()
                .height(8.dp),
            color = MaterialTheme.colorScheme.primary
        )
    }
}

// Main Sign-Up Form Screen
@Composable
fun SignUpFormDemoScreen(
    viewModel: SignUpFormViewModel = viewModel()
) {
    var showSuccess by remember { mutableStateOf(false) }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(20.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Header
        Text(
            "Create Account",
            style = MaterialTheme.typography.headlineSmall
        )
        
        Text(
            "Sign up for UniCore Validation Demo",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        
        // Progress
        FormProgressIndicator(viewModel.completionPercentage)
        
        Divider()
        
        // Personal Information Section
        Text(
            "Personal Information",
            style = MaterialTheme.typography.labelLarge
        )
        
        SignUpFormField(
            label = "First Name",
            icon = Icons.Default.Person,
            placeholder = "John",
            value = viewModel.firstName.value,
            onValueChange = { viewModel.updateFirstName(it) },
            error = viewModel.firstNameError.value,
            isValid = viewModel.isFirstNameValid.value
        )
        
        SignUpFormField(
            label = "Last Name",
            icon = Icons.Default.Person,
            placeholder = "Doe",
            value = viewModel.lastName.value,
            onValueChange = { viewModel.updateLastName(it) },
            error = viewModel.lastNameError.value,
            isValid = viewModel.isLastNameValid.value
        )
        
        Divider()
        
        // Account Information Section
        Text(
            "Account Information",
            style = MaterialTheme.typography.labelLarge
        )
        
        SignUpFormField(
            label = "Email",
            icon = Icons.Default.Email,
            placeholder = "user@example.com",
            value = viewModel.email.value,
            onValueChange = { viewModel.updateEmail(it) },
            error = viewModel.emailError.value,
            isValid = viewModel.isEmailValid.value
        )
        
        SignUpFormField(
            label = "Username",
            icon = Icons.Default.Person,
            placeholder = "john_doe",
            value = viewModel.username.value,
            onValueChange = { viewModel.updateUsername(it) },
            error = viewModel.usernameError.value,
            isValid = viewModel.isUsernameValid.value
        )
        
        Divider()
        
        // Security Section
        Text(
            "Security",
            style = MaterialTheme.typography.labelLarge
        )
        
        SignUpFormField(
            label = "Password",
            icon = Icons.Default.Lock,
            placeholder = "••••••••",
            value = viewModel.password.value,
            onValueChange = { viewModel.updatePassword(it) },
            error = viewModel.passwordError.value,
            isValid = viewModel.isPasswordValid.value,
            isPassword = true
        )
        
        SignUpFormField(
            label = "Confirm Password",
            icon = Icons.Default.Lock,
            placeholder = "••••••••",
            value = viewModel.confirmPassword.value,
            onValueChange = { viewModel.updateConfirmPassword(it) },
            error = viewModel.confirmPasswordError.value,
            isValid = viewModel.isConfirmPasswordValid.value,
            isPassword = true
        )
        
        Spacer(modifier = Modifier.height(12.dp))
        
        // Action Buttons
        Button(
            onClick = { showSuccess = true },
            modifier = Modifier
                .fillMaxWidth()
                .height(48.dp),
            enabled = viewModel.isFormValid
        ) {
            Text("Create Account")
        }
        
        if (showSuccess) {
            AlertDialog(
                onDismissRequest = { showSuccess = false },
                title = { Text("Success") },
                text = { Text("Account created successfully!") },
                confirmButton = {
                    Button(onClick = { showSuccess = false }) {
                        Text("OK")
                    }
                }
            )
        }
        
        Spacer(modifier = Modifier.height(20.dp))
    }
}
