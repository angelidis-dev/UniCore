package com.example.unicorevalidationdemo.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material3.Button
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update

// MARK: - Email Validation Screen

@Composable
fun EmailValidationScreen() {
    val viewModel = remember { EmailValidationDemoViewModel() }
    val state = viewModel.state
    
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(rememberScrollState())
            .padding(16.dp)
    ) {
        Text(
            "Real-Time Email Validation",
            style = MaterialTheme.typography.headlineSmall,
            modifier = Modifier.padding(bottom = 8.dp)
        )
        
        Text(
            "Type an email and see validation in action",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(bottom = 20.dp)
        )
        
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 20.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            OutlinedTextField(
                value = state.email,
                onValueChange = { viewModel.updateEmail(it) },
                label = { Text("Email Address") },
                modifier = Modifier
                    .weight(1f)
                    .padding(end = 8.dp),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email),
                singleLine = true
            )
            
            if (state.isValid && state.email.isNotEmpty()) {
                Icon(
                    imageVector = Icons.Filled.Check,
                    contentDescription = "Valid",
                    tint = Color.Green,
                    modifier = Modifier.padding(8.dp)
                )
            }
        }
        
        if (state.error != null) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(
                        Color(0xFFFFEBEE),
                        shape = RoundedCornerShape(4.dp)
                    )
                    .padding(12.dp)
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Filled.Warning,
                        contentDescription = "Error",
                        tint = Color.Red,
                        modifier = Modifier.padding(end = 8.dp)
                    )
                    
                    Column {
                        Text(
                            "Validation Error",
                            style = MaterialTheme.typography.labelSmall,
                            color = Color.Red
                        )
                        Text(
                            state.error!!.messageKey,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Password Validation Screen

@Composable
fun PasswordValidationScreen() {
    val viewModel = remember { PasswordValidationDemoViewModel() }
    val state = viewModel.state
    val showPassword = remember { mutableStateOf(false) }
    val showConfirm = remember { mutableStateOf(false) }
    
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(rememberScrollState())
            .padding(16.dp)
    ) {
        Text(
            "Password Validation",
            style = MaterialTheme.typography.headlineSmall,
            modifier = Modifier.padding(bottom = 8.dp)
        )
        
        Text(
            "Create a strong password with real-time feedback",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(bottom = 20.dp)
        )
        
        // Password Input
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 8.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = androidx.compose.foundation.layout.Arrangement.SpaceBetween
        ) {
            Text(
                "Password",
                style = MaterialTheme.typography.labelMedium
            )
            
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    state.passwordStrength.label,
                    style = MaterialTheme.typography.labelSmall,
                    color = state.passwordStrength.color
                )
                
                Box(
                    modifier = Modifier
                        .padding(start = 4.dp)
                        .background(
                            state.passwordStrength.color,
                            shape = RoundedCornerShape(4.dp)
                        )
                        .padding(4.dp)
                )
            }
        }
        
        OutlinedTextField(
            value = state.password,
            onValueChange = { viewModel.updatePassword(it) },
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 16.dp),
            visualTransformation = if (showPassword.value) 
                VisualTransformation.None else PasswordVisualTransformation(),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
            singleLine = true
        )
        
        // Confirm Password
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 8.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = androidx.compose.foundation.layout.Arrangement.SpaceBetween
        ) {
            Text(
                "Confirm Password",
                style = MaterialTheme.typography.labelMedium
            )
            
            if (state.isConfirmValid) {
                Icon(
                    imageVector = Icons.Filled.Check,
                    contentDescription = "Valid",
                    tint = Color.Green
                )
            }
        }
        
        OutlinedTextField(
            value = state.confirmPassword,
            onValueChange = { viewModel.updateConfirmPassword(it) },
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 20.dp),
            visualTransformation = if (showConfirm.value) 
                VisualTransformation.None else PasswordVisualTransformation(),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
            singleLine = true
        )
        
        // Status
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(
                    MaterialTheme.colorScheme.surfaceVariant,
                    shape = RoundedCornerShape(4.dp)
                )
                .padding(12.dp)
        ) {
            Column {
                StatusRow("Password Valid", state.isPasswordValid)
                StatusRow("Confirmed", state.isConfirmValid)
                StatusRow("Strong Password", state.passwordStrength == PasswordStrength.STRONG)
            }
        }
        
        Button(
            onClick = { },
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 20.dp),
            enabled = state.allValid
        ) {
            Text("Create Account")
        }
    }
}

// MARK: - Sign-Up Form Screen

@Composable
fun SignUpFormScreen() {
    val viewModel = remember { SignUpFormDemoViewModel() }
    val state = viewModel.state
    
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(rememberScrollState())
            .padding(16.dp)
    ) {
        Text(
            "Create Account",
            style = MaterialTheme.typography.headlineSmall,
            modifier = Modifier.padding(bottom = 4.dp)
        )
        
        Text(
            "Form completion: ${(state.completionPercentage * 100).toInt()}%",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(bottom = 12.dp)
        )
        
        // Progress bar
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(
                    Color(0xFFE0E0E0),
                    shape = RoundedCornerShape(4.dp)
                )
                .padding(0.dp)
        ) {
            Box(
                modifier = Modifier
                    .fillMaxWidth(state.completionPercentage.toFloat())
                    .background(
                        Color.Blue,
                        shape = RoundedCornerShape(4.dp)
                    )
                    .padding(vertical = 8.dp)
            )
        }
        
        // Personal Info Section
        FormSection(title = "Personal Information") {
            FormField(
                label = "First Name",
                value = state.firstName,
                onValueChange = { viewModel.updateFirstName(it) },
                error = state.firstNameError,
                isValid = state.isFirstNameValid
            )
            
            FormField(
                label = "Last Name",
                value = state.lastName,
                onValueChange = { viewModel.updateLastName(it) },
                error = state.lastNameError,
                isValid = state.isLastNameValid
            )
        }
        
        // Account Info Section
        FormSection(title = "Account Information") {
            FormField(
                label = "Email",
                value = state.email,
                onValueChange = { viewModel.updateEmail(it) },
                error = state.emailError,
                isValid = state.isEmailValid,
                keyboardType = KeyboardType.Email
            )
            
            FormField(
                label = "Username",
                value = state.username,
                onValueChange = { viewModel.updateUsername(it) },
                error = state.usernameError,
                isValid = state.isUsernameValid
            )
        }
        
        // Security Section
        FormSection(title = "Security") {
            FormField(
                label = "Password",
                value = state.password,
                onValueChange = { viewModel.updatePassword(it) },
                error = state.passwordError,
                isValid = state.isPasswordValid,
                isPassword = true
            )
            
            FormField(
                label = "Confirm Password",
                value = state.confirmPassword,
                onValueChange = { viewModel.updateConfirmPassword(it) },
                error = state.confirmPasswordError,
                isValid = state.isConfirmPasswordValid,
                isPassword = true
            )
        }
        
        Button(
            onClick = { },
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 20.dp),
            enabled = state.isFormValid
        ) {
            Text("Create Account")
        }
    }
}

// MARK: - Helper Composables

@Composable
fun FormSection(
    title: String,
    content: @Composable () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .background(
                MaterialTheme.colorScheme.surfaceVariant,
                shape = RoundedCornerShape(4.dp)
            )
            .padding(12.dp)
            .padding(bottom = 16.dp)
    ) {
        Text(
            title,
            style = MaterialTheme.typography.labelMedium,
            modifier = Modifier.padding(bottom = 12.dp)
        )
        
        content()
    }
}

@Composable
fun FormField(
    label: String,
    value: String,
    onValueChange: (String) -> Unit,
    error: ValidationError?,
    isValid: Boolean,
    keyboardType: KeyboardType = KeyboardType.Text,
    isPassword: Boolean = false
) {
    Column(
        modifier = Modifier.padding(bottom = 12.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 4.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = androidx.compose.foundation.layout.Arrangement.SpaceBetween
        ) {
            Text(
                label,
                style = MaterialTheme.typography.labelSmall
            )
            
            if (isValid && value.isNotEmpty()) {
                Icon(
                    imageVector = Icons.Filled.Check,
                    contentDescription = "Valid",
                    tint = Color.Green,
                    modifier = Modifier.padding(end = 8.dp)
                )
            }
        }
        
        OutlinedTextField(
            value = value,
            onValueChange = onValueChange,
            modifier = Modifier.fillMaxWidth(),
            visualTransformation = if (isPassword) 
                PasswordVisualTransformation() else VisualTransformation.None,
            keyboardOptions = KeyboardOptions(keyboardType = keyboardType),
            singleLine = true
        )
        
        if (error != null && value.isNotEmpty()) {
            Text(
                error.messageKey,
                style = MaterialTheme.typography.bodySmall,
                color = Color.Red,
                modifier = Modifier.padding(top = 4.dp)
            )
        }
    }
}

@Composable
fun StatusRow(
    label: String,
    isValid: Boolean
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = if (isValid) Icons.Filled.Check else Icons.Filled.Close,
            contentDescription = null,
            tint = if (isValid) Color.Green else Color.Gray,
            modifier = Modifier.padding(end = 8.dp)
        )
        
        Text(
            label,
            style = MaterialTheme.typography.bodySmall
        )
    }
}

// MARK: - Validation Error

data class ValidationError(
    val code: String,
    val messageKey: String,
    val metadata: Map<String, Any>? = null
)

// MARK: - Password Strength

enum class PasswordStrength(val label: String, val color: Color) {
    WEAK("Weak", Color.Red),
    FAIR("Fair", Color(0xFFFFA500)),
    GOOD("Good", Color.Yellow),
    STRONG("Strong", Color.Green)
}
