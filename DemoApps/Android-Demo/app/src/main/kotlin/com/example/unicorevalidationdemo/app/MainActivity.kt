package com.example.unicorevalidationdemo.app

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.unicorevalidationdemo.screens.EmailValidationScreen
import com.example.unicorevalidationdemo.screens.PasswordValidationScreen
import com.example.unicorevalidationdemo.screens.SignUpFormScreen

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun UniCoreValidationDemoApp() {
    val navController = rememberNavController()
    
    NavHost(navController = navController, startDestination = "home") {
        composable("home") {
            HomeScreen(navController)
        }
        composable("email") {
            DemoScaffold(
                title = "Email Validation",
                navController = navController
            ) {
                EmailValidationScreen()
            }
        }
        composable("password") {
            DemoScaffold(
                title = "Password Validation",
                navController = navController
            ) {
                PasswordValidationScreen()
            }
        }
        composable("signup") {
            DemoScaffold(
                title = "Sign-Up Form",
                navController = navController
            ) {
                SignUpFormScreen()
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(navController: NavHostController) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("UniCore Validation") }
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding),
            verticalArrangement = Arrangement.Top
        ) {
            LazyColumn {
                item {
                    DemoMenuItem(
                        title = "Email Validation",
                        description = "Real-time email feedback",
                        icon = "✉️",
                        onClick = { navController.navigate("email") }
                    )
                }
                item {
                    DemoMenuItem(
                        title = "Password Validation",
                        description = "Strength indicator & confirmation",
                        icon = "🔒",
                        onClick = { navController.navigate("password") }
                    )
                }
                item {
                    DemoMenuItem(
                        title = "Complete Sign-Up Form",
                        description = "6-field form with validation",
                        icon = "📋",
                        onClick = { navController.navigate("signup") }
                    )
                }
            }
        }
    }
}

@Composable
fun DemoMenuItem(
    title: String,
    description: String,
    icon: String,
    onClick: () -> Unit
) {
    Button(
        onClick = onClick,
        modifier = Modifier
            .padding(
                horizontal = 16.dp,
                vertical = 8.dp
            )
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text("$icon  $title")
            Text(
                description,
                modifier = Modifier.padding(top = 4.dp)
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DemoScaffold(
    title: String,
    navController: NavHostController,
    content: @Composable () -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(title) },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.Filled.ArrowBack, contentDescription = "Back")
                    }
                }
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
        ) {
            content()
        }
    }
}
