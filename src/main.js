const { app, BrowserWindow, globalShortcut, ipcMain, clipboard } = require('electron');
const path = require('path');

let mainWindow;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 920,
    height: 600,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false
    }
  });
  mainWindow.loadFile(path.join(__dirname, 'index.html'));
  mainWindow.on('close', (e) => { 
    e.preventDefault(); 
    mainWindow.hide(); 
  });
}

app.whenReady().then(() => {
  createWindow();
  globalShortcut.register('Alt+Shift+P', () => {
    if (mainWindow.isVisible()) {
      mainWindow.hide();
    } else {
      mainWindow.show();
      mainWindow.focus();
    }
  });
});

ipcMain.on('copy-text', (event, text) => {
  clipboard.writeText(text);
});

ipcMain.handle('paste-text', async () => {
  return clipboard.readText();
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
