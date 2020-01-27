# megacademia

A Twitter-like social APP for academia.

这是一款为学术界打造的类微博、Twitter的社交软件，基于开源引擎Mastodon。旨在为学术人员打造一个知识分享、学术交流的平台。

# 文件结构
这里仅介绍 lib 目录，该目录下主要存放Megacademia的Flutter开发前端代码。

## 目录结构
**/lib**：

- **actions**
- **components**：组件目录，包含具体的、可复用的组件。
- **models**：模型目录，包含具体的开发模型，如实体、表单以及状态。
    - **entity**：实体模型，是对数据的建模
    - **form**：表单模型
    - **state**：状态模型
- **pages**：页面目录，虽然在Flutter中页面也是组件，但页面面作为路由的入口，还是将其从components中独立出来以提高开发管理的效率。详细见下面「框架与导航」。
- **reducers**
- **services**：服务目录：处理后端数据业务请求。
- **utils**：工具目录：包含一些具体的工具类，如HTTP请求工具类等。
- **app.dart**：APP入口文件。
- **config.dart**：APP应用配置文件。
- **factory.dart**：工厂类文件：包含一些应用中所需对象的工厂类。
- **theme.dart**：主题配置文件：决定了应用的外观，如字号、字体、字体颜色、背景颜色......等等。通过该文件可以对APP外观进行统一的配置、修改。
- **main_dev.dart**：包含一些在开发、调试模式下的配置，包括打开日志、debug、模拟API......等等。
- **main.dart**：标准main文件，用于生产模式。

## 框架与导航
- **BootstrapPage**：启动页，会进行一些与服务端的交互，如判断用户登录状态、检查应用版本号......等等。
- **LoginPage**：登录页面。
- **RegisterPage**：注册页面。
- **TabPage**：标签页。
    - **HomePage**：应用主页，即动态页面。
    - **MePage**：用户页面

