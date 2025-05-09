export default {
  // apps quickmenu
  apps: [{
    icon: 'mdi-email-outline',
    text: 'Profile',
    key: 'menu.profile',
    subtitle: 'Hey!',
    link: '/users/edit'
  }],

  // user dropdown menu
  user: [
    // { icon: 'mdi-account-box-outline', key: 'menu.profile', text: 'Profile', link: '/users/edit' },
    { icon: 'mdi-lock-reset', key: 'menu.authReset', text: 'Reset Password', link: '/auth/reset-password' }
  ]
}
