// Android Example - Kotlin
// This shows how to integrate UniCoreValidation Swift package in Android via Swift SDK

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

// Swift SDK Import (simulated - would be actual Swift package)
// import UniCoreValidation

/**
 * Android ViewModel for Email Validation Demo
 * 
 * Shows how to integrate UniCoreValidation with Android's Jetpack Compose
 * using the Swift SDK for cross-platform validation
 */
class EmailValidationViewModel : ViewModel() {
    val email = mutableStateOf("")
    val validationError = mutableStateOf<ValidationErrorModel?>(null)
    val isValid = mutableStateOf(false)
    
    fun validateEmail(input: String) {
        email.value = input
        
        // Call Swift validation via SDK
        // In production, this would use Swift SDK bridge
        val result = validateEmailSwift(input)
        
        isValid.value = result.isValid
        validationError.value = result.errors?.firstOrNull()
    }
    
    // Simulated Swift SDK bridge - in production this uses actual Swift interop
    private fun validateEmailSwift(input: String): ValidationResultModel {
        return when {
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
            !isValidEmail(input) -> ValidationResultModel(
                isValid = false,
                errors = listOf(
                    ValidationErrorModel(
                        code = "email.invalid",
                        messageKey = "validation.email.invalid",
                        metadata = emptyMap()
                    )
                )
            )
            else -> ValidationResultModel(isValid = true, errors = null)
        }
    }
    
    private fun isValidEmail(email: String): Boolean {
        val emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
        return Regex(emailPattern).matches(email)
    }
}

// Data models matching Swift ValidationError and ValidationResult
data class ValidationErrorModel(
    val code: String,
    val messageKey: String,
    val metadata: Map<String, String>
)

data class ValidationResultModel(
    val isValid: Boolean,
    val errors: List<ValidationErrorModel>?
)

// UI Composable for Email Validation Demo
@Composable
fun EmailValidationDemoScreen(
    viewModel: EmailValidationViewModel = viewModel()
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(20.dp)
            .verticalScroll(rememberScrollState())
    ) {
        Text(
            "Email Validation Demo",
            style = MaterialTheme.typography.headlineSmall,
            modifier = Modifier.padding(bottom = 8.dp)
        )
        
        Text(
            "Real-time email validation using UniCoreValidation Swift package",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(bottom = 20.dp)
        )
        
        // Email Input Field
        OutlinedTextField(
            value = viewModel.email.value,
            onValueChange = { viewModel.validateEmail(it) },
            label = { Text("Email Address") },
            leadingIcon = { Icon(Icons.Default.Email, contentDescription = null) },
            trailingIcon = if (viewModel.isValid.value) {
                {
                    Icon(
                        Icons.Default.CheckCircle,
                        contentDescription = "Valid",
                        tint = Color.Green
                    )
                }
            } else null,
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 12.dp),
            keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                keyboardType = androidx.compose.ui.text.input.KeyboardType.Email
            )
        )
        
        // Error Display
        viewModel.validationError.value?.let { error ->
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(
                        color = Color(0xFFFFEBEE),
                        shape = RoundedCornerShape(8.dp)
                    ),
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
                        contentDescription = "Error",
                        tint = Color(0xFFC62828),
                        modifier = Modifier.size(20.dp)
                    )
                    
                    Column {
                        Text(
                            "Validation Error",
                            style = MaterialTheme.typography.labelSmall,
                            color = Color(0xFFC62828)
                        )
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
        
        Spacer(modifier = Modifier.height(20.dp))
        
        Button(
            onClick = { },
            modifier = Modifier
                .fillMaxWidth()
                .padding(12.dp),
            enabled = viewModel.isValid.value
        ) {
            Text("Continue")
        }
    }
}

// Preview (in actual Android project)
// @Preview(showBackground = true)
// @Composable
// fun EmailValidationPreview() {
//     EmailValidationDemoScreen()
// }
