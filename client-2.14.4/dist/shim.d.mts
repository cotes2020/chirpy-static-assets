type WalineCommentSorting = 'latest' | 'oldest' | 'hottest';
type WalineEmojiPresets = `//${string}` | `http://${string}` | `https://${string}`;
interface WalineEmojiInfo {
    /**
     * 选项卡上的 Emoji 名称
     *
     * Emoji name show on tab
     */
    name: string;
    /**
     * 所在文件夹链接
     *
     * Current folder link
     */
    folder?: string;
    /**
     * Emoji 通用路径前缀
     *
     * Common prefix of Emoji icons
     */
    prefix?: string;
    /**
     * Emoji 图片的类型，会作为文件扩展名使用
     *
     * Type of Emoji icons, will be regarded as file extension
     */
    type?: string;
    /**
     * 选项卡显示的 Emoji 图标
     *
     * Emoji icon show on tab
     */
    icon: string;
    /**
     * Emoji 图片列表
     *
     * Emoji image list
     */
    items: string[];
}
type WalineEmojiMaps = Record<string, string>;
type WalineLoginStatus = 'enable' | 'disable' | 'force';
interface WalineSearchImageData extends Record<string, unknown> {
    /**
     * 图片链接
     *
     * Image link
     */
    src: string;
    /**
     * 图片标题
     *
     * @description 用于图片的 alt 属性
     *
     * Image title
     *
     * @description Used for alt attribute of image
     */
    title?: string;
    /**
     * 图片缩略图
     *
     * @description 为了更好的加载性能，我们会优先在列表中使用此缩略图
     *
     * Image preview link
     *
     * @description For better loading performance, we will use this thumbnail first in the list
     *
     * @default src
     */
    preview?: string;
}
type WalineSearchResult = WalineSearchImageData[];
interface WalineSearchOptions {
    /**
     * 搜索操作
     *
     * Search action
     */
    search: (word: string) => Promise<WalineSearchResult>;
    /**
     * 打开列表时展示的默认结果
     *
     * Default result when opening list
     *
     * @default () => search('')
     */
    default?: () => Promise<WalineSearchResult>;
    /**
     * 获取更多的操作
     *
     * @description 会在列表滚动到底部时触发，如果你的搜索服务支持分页功能，你应该设置此项实现无限滚动
     *
     * Fetch more action
     *
     * @description It will be triggered when the list scrolls to the bottom. If your search service supports paging, you should set this to achieve infinite scrolling
     *
     * @default (word) => search(word)
     */
    more?: (word: string, currentCount: number) => Promise<WalineSearchResult>;
}
type WalineMeta = 'nick' | 'mail' | 'link';
type WalineImageUploader = (image: File) => Promise<string>;
type WalineHighlighter = (code: string, lang: string) => string;
type WalineTexRenderer = (blockMode: boolean, tex: string) => string;

interface WalineCommentData {
    /**
     * User Nickname
     */
    nick: string;
    /**
     * User email
     */
    mail: string;
    /**
     * User link
     */
    link?: string;
    /**
     * Content of comment
     */
    comment: string;
    /**
     * User Agent
     */
    ua: string;
    /**
     * Parent comment id
     */
    pid?: string;
    /**
     * Root comment id
     */
    rid?: string;
    /**
     * User id being at
     */
    at?: string;
    /**
     * Comment link
     */
    url: string;
    /**
     * Recaptcha Token
     */
    recaptchaV3?: string;
}
type WalineCommentStatus = 'approved' | 'waiting' | 'spam';
interface WalineComment extends Exclude<WalineCommentData, 'ua'> {
    /**
     * User avatar
     */
    avatar: string;
    /**
     * User type
     */
    type?: 'administrator' | 'guest' | `verify:${string}`;
    objectId: string;
    /**
     * Time ISOString when the comment is created
     */
    createdAt: string;
    insertedAt: string;
    updatedAt: string;
    children: WalineComment[];
    sticky?: boolean;
    browser?: string;
    os?: string;
    level?: number;
    addr?: string;
    label?: string;
    user_id?: string | number;
    status?: WalineCommentStatus;
    like?: number;
    orig?: string;
}

interface WalineDateLocale {
    seconds: string;
    minutes: string;
    hours: string;
    days: string;
    now: string;
}
type WalineLevelLocale = Record<`level${number}`, string>;
interface WalineReactionLocale {
    reactionTitle: string;
    reaction0: string;
    reaction1: string;
    reaction2: string;
    reaction3: string;
    reaction4: string;
    reaction5: string;
    reaction6: string;
    reaction7: string;
    reaction8: string;
}
interface WalineLocale extends WalineDateLocale, WalineLevelLocale, WalineReactionLocale {
    nick: string;
    mail: string;
    link: string;
    optional: string;
    placeholder: string;
    sofa: string;
    submit: string;
    comment: string;
    refresh: string;
    more: string;
    uploading: string;
    login: string;
    admin: string;
    sticky: string;
    word: string;
    anonymous: string;
    gif: string;
    gifSearchPlaceholder: string;
    approved: string;
    waiting: string;
    spam: string;
    unsticky: string;
    oldest: string;
    latest: string;
    hottest: string;
    nickError: string;
    mailError: string;
    wordHint: string;
    like: string;
    cancelLike: string;
    reply: string;
    cancelReply: string;
    preview: string;
    emoji: string;
    uploadImage: string;
    profile: string;
    logout: string;
}

interface WalineProps {
    /**
     * Waline 的服务端地址
     *
     * Waline server address url
     */
    serverURL: string;
    /**
     * 当前 _文章页_ 路径，用于区分不同的 _文章页_ ，以保证正确读取该 _文章页_ 下的评论列表
     *
     * 你可以将其设置为 `window.location.pathname`
     *
     * Article path id. Used to distinguish different _article pages_ to ensure loading the correct comment list under the _article page_.
     *
     * You can set it to `window.location.pathname`
     */
    path: string;
    /**
     * 评论者相关属性
     *
     * `Meta` 可选值: `'nick'`, `'mail'`, `'link'`
     *
     * Reviewer attributes.
     *
     * Optional values for `Meta`: `'nick'`, `'mail'`, `'link'`
     *
     * @default ['nick', 'mail', 'link']
     */
    meta?: WalineMeta[];
    /**
     * 设置**必填项**，默认昵称为匿名
     *
     * Set required fields, default anonymous with nickname
     *
     * @default []
     */
    requiredMeta?: WalineMeta[];
    /**
     * 评论字数限制。填入单个数字时为最大字数限制
     *
     * @more 设置为 `0` 时无限制
     *
     * Comment word s limit. When a single number is filled in, it 's the maximum number of comment words.
     *
     * @more No limit when set to `0`.
     *
     * @default 0
     */
    wordLimit?: number | [number, number];
    /**
     * 评论列表分页，每页条数
     *
     * number of pages per page
     *
     * @default 10
     */
    pageSize?: number;
    /**
     * Waline 显示语言
     *
     * 可选值:
     *
     * - `'zh'`
     * - `'zh-cn'`
     * - `'zh-CN'`
     * - `'zh-tw'`
     * - `'zh-TW'`
     * - `'en'`
     * - `'en-US'`
     * - `'en-us'`
     * - `'jp'`
     * - `'jp-jp'`
     * - `'jp-JP'`
     * - `'pt-br'`
     * - `'pt-BR'`
     * - `'ru'`
     * - `'ru-ru'`
     * - `'ru-RU'`
     *
     * Display language for waline
     *
     * Optional value:
     *
     * - `'zh'`
     * - `'zh-cn'`
     * - `'zh-CN'`
     * - `'zh-tw'`
     * - `'zh-TW'`
     * - `'en'`
     * - `'en-US'`
     * - `'en-us'`
     * - `'jp'`
     * - `'jp-jp'`
     * - `'jp-JP'`
     * - `'pt-br'`
     * - `'pt-BR'`
     * - `'ru'`
     * - `'ru-ru'`
     * - `'ru-RU'`
     *
     * @default navigator.language
     */
    lang?: string;
    /**
     * 自定义 waline 语言显示
     *
     * @see [自定义语言](https://waline.js.org/client/i18n.html)
     *
     * Custom display language in waline
     *
     * @see [I18n](https://waline.js.org/en/client/i18n.html)
     */
    locale?: Partial<WalineLocale>;
    /**
     * 评论列表排序方式
     *
     * Sorting method for comment list
     *
     * @default 'latest'
     */
    commentSorting?: WalineCommentSorting;
    /**
     * 是否启用暗黑模式适配
     *
     * @more 设置 `'auto'` 会根据设备暗黑模式自适应。填入 CSS 选择器会在对应选择器生效时启用夜间模式。
     *
     * Whether to enable darkmode support
     *
     * @more Setting `'auto'` will display darkmode due to device settings. Filling in CSS selector will enable darkmode only when the selector match waline ancestor nodes.
     */
    dark?: string | boolean;
    /**
     * 设置表情包
     *
     * Set Emojis
     *
     * @default ['//unpkg.com/@waline/emojis@1.1.0/weibo']
     */
    emoji?: (WalineEmojiInfo | WalineEmojiPresets)[] | boolean;
    /**
     * 设置搜索功能
     *
     * Customize Search feature
     *
     * @default true
     */
    search?: WalineSearchOptions | boolean;
    /**
     * 代码高亮
     *
     * Code highlighting
     *
     * @default true
     */
    highlighter?: WalineHighlighter | boolean;
    /**
     * 自定义图片上传方法，方便更好的存储图片
     *
     * 方法执行时会将图片对象传入。
     *
     * Custom image upload callback to manage picture by yourself.
     *
     * We will pass a picture file object when execute it.
     *
     * @default true
     */
    imageUploader?: WalineImageUploader | boolean;
    /**
     * 自定义数学公式处理方法，用于预览。
     *
     * Custom math formula parse callback for preview.
     *
     * @default true
     */
    texRenderer?: WalineTexRenderer | boolean;
    /**
     *
     * 登录模式状态，可选值:
     *
     * - `'enable'`: 启用登录 (默认)
     * - `'disable'`: 禁用登录，用户只能填写信息评论
     * - `'force'`: 强制登录，用户必须注册并登录才可发布评论
     *
     * Login mode status, optional values:
     *
     * - `'enable'`: enable login (default)
     * - `'disable'`: Login is disabled, users should fill in information to comment
     * - `'force'`: Forced login, users must login to comment
     *
     * @default 'enable'
     */
    login?: WalineLoginStatus;
    /**
     * 是否在页脚展示版权信息
     *
     * 为了支持 Waline，我们强烈建议你开启它
     *
     * Whether show copyright in footer
     *
     * We strongly recommended you to keep it on to support waline
     *
     * @default true
     */
    copyright?: boolean;
    /**
     * recaptcha v3 client key
     */
    recaptchaV3Key?: string;
    /**
     * reaction
     */
    reaction?: string[] | boolean;
}

interface WalineInitOptions extends Omit<WalineProps, 'path'> {
    /**
     * Waline 的初始化挂载器。必须是一个**有效的** CSS 选择器 或 HTML 元素
     *
     * The DOM element to be mounted on initialization. It must be a **valid** CSS selector string or HTML Element.
     */
    el?: string | HTMLElement | null;
    /**
     * 评论数统计
     *
     * Comment number support
     *
     * @default false
     */
    comment?: string | boolean;
    /**
     * 页面访问量统计
     *
     * Pageview number support
     *
     * @default false
     */
    pageview?: string | boolean;
    /**
     * 当前 _文章页_ 路径，用于区分不同的 _文章页_ ，以保证正确读取该 _文章页_ 下的评论列表
     *
     * 你可以将其设置为 `window.location.pathname`
     *
     * Article path id. Used to distinguish different _article pages_ to ensure loading the correct comment list under the _article page_.
     *
     * You can set it to `window.location.pathname`
     *
     * @default window.location.pathname
     */
    path?: string;
}
type WalineAbort = (reason?: any) => void;

type Locales = Record<string, WalineLocale>;
declare const defaultLocales: Locales;

interface WalineCommentCountOptions {
    /**
     * Waline 服务端地址
     *
     * Waline server url
     */
    serverURL: string;
    /**
     * 评论数 CSS 选择器
     *
     * Comment count CSS selector
     *
     * @default '.waline-comment-count'
     */
    selector?: string;
    /**
     * 需要获取的默认路径
     *
     * Path to be fetched by default
     *
     * @default window.location.pathname
     */
    path?: string;
    /**
     * 错误提示消息所使用的语言
     *
     * Language of error message
     *
     * @default navigator.language
     */
    lang?: string;
}
declare const commentCount: ({ serverURL, path, selector, lang, }: WalineCommentCountOptions) => WalineAbort;

interface WalineInstance {
    /**
     * Waline 被挂载到的元素
     *
     * @description 当通过 `el: null` 初始化，值为 `null`
     *
     * Element where Waline is mounted
     *
     * @description when initialized with `el: null`, it will be `null`
     */
    el: HTMLElement | null;
    /**
     * 更新 Waline 实例
     *
     * @description 只要不设置`path` 选项，更新时它就会被重置为 `windows.location.pathname`
     *
     * Update Waline instance
     *
     * @description when not setting `path` option, it will be reset to `window.location.pathname`
     */
    update: (newOptions?: Partial<Omit<WalineInitOptions, 'el'>>) => void;
    /**
     * 取消挂载并摧毁 Waline 实例
     *
     * Unmount and destroy Waline instance
     */
    destroy: () => void;
}
declare const init: ({ el, path, comment, pageview, ...initProps }: WalineInitOptions) => WalineInstance | null;

interface WalinePageviewCountOptions {
    /**
     * Waline 服务端地址
     *
     * Waline server url
     */
    serverURL: string;
    /**
     * 浏览量 CSS 选择器
     *
     * Pageview CSS selector
     *
     * @default '.waline-pageview-count'
     */
    selector?: string;
    /**
     * 需要更新和获取的路径
     *
     * Path to be fetched and updated
     *
     * @default window.location.pathname
     */
    path?: string;
    /**
     * 是否在查询时更新 path 的浏览量
     *
     * Whether update pageviews when fetching path result
     *
     * @default true
     */
    update?: boolean;
    /**
     * 错误提示消息所使用的语言
     *
     * Language of error message
     *
     * @default navigator.language
     */
    lang?: string;
}
declare const pageviewCount: ({ serverURL, path, selector, update, lang, }: WalinePageviewCountOptions) => WalineAbort;

declare const version: string;

interface WalineRecentCommentsOptions {
    /**
     * Waline 服务端地址
     *
     * Waline serverURL
     */
    serverURL: string;
    /**
     * 获取最新评论的数量
     *
     * fetch number of latest comments
     */
    count: number;
    /**
     * 需要挂载的元素
     *
     * Element to be mounted
     */
    el?: string | HTMLElement;
    /**
     * 错误提示消息所使用的语言
     *
     * Language of error message
     *
     * @default navigator.language
     */
    lang?: string;
}
interface WalineRecentCommentsResult {
    /**
     * 评论数据
     *
     * Comment Data
     */
    comments: WalineComment[];
    /**
     * 取消挂载挂件
     *
     * Umount widget
     */
    destroy: () => void;
}
declare const RecentComments: ({ el, serverURL, count, lang, }: WalineRecentCommentsOptions) => Promise<WalineRecentCommentsResult>;

interface WalineUser extends Pick<WalineComment, 'nick' | 'link' | 'avatar' | 'label' | 'level'> {
    count: number;
}

interface WalineUserListOptions {
    /**
     * Waline 服务端地址
     *
     * Waline serverURL
     */
    serverURL: string;
    /**
     * 获取用户列表的数量
     *
     * fetch number of user list
     */
    count: number;
    /**
     * 需要挂载的元素
     *
     * Element to be mounted
     */
    el?: string | HTMLElement;
    /**
     * 错误提示消息所使用的语言
     *
     * Language of error message
     *
     * @default navigator.language
     */
    lang?: string;
    /**
     * 自定义 waline 语言显示
     *
     * @see [自定义语言](https://waline.js.org/client/i18n.html)
     *
     * Custom display language in waline
     *
     * @see [I18n](https://waline.js.org/en/client/i18n.html)
     */
    locale?: WalineLocale;
    /**
     * 列表模式还是头像墙模式
     *
     * list mode or avatar wall mode
     */
    mode: 'list' | 'wall';
}
interface WalineUserListResult {
    /**
     * 用户数据
     *
     * User Data
     */
    users: WalineUser[];
    /**
     * 取消挂载挂件
     *
     * Umount widget
     */
    destroy: () => void;
}
declare const UserList: ({ el, serverURL, count, locale, lang, mode, }: WalineUserListOptions) => Promise<WalineUserListResult>;

export { RecentComments, UserList, WalineAbort, WalineComment, WalineCommentCountOptions, WalineCommentData, WalineCommentSorting, WalineCommentStatus, WalineDateLocale, WalineEmojiInfo, WalineEmojiMaps, WalineEmojiPresets, WalineHighlighter, WalineImageUploader, WalineInitOptions, WalineInstance, WalineLevelLocale, WalineLocale, WalineLoginStatus, WalineMeta, WalinePageviewCountOptions, WalineProps, WalineReactionLocale, WalineRecentCommentsOptions, WalineRecentCommentsResult, WalineSearchImageData, WalineSearchOptions, WalineSearchResult, WalineTexRenderer, WalineUserListOptions, WalineUserListResult, commentCount, defaultLocales, init, pageviewCount, version };
